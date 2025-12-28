#!/usr/bin/env bash
set -euo pipefail

########################################
# CONFIGURATION
########################################
# Adjust these paths to your environment
WORKDIR=/home/lab/kim/hd/rnaseq/
GENOME_DIR=/home/lab/kim/hd/genome/SkHd3
RNA_DIR="$WORKDIR/reads_pe"
SOURCES_TSV="$(dirname "$0")/StringTie_sources.tsv"

GENOME_FASTA="$GENOME_DIR/SkHd3_nextpolish_scaffolds.fasta"
GENOME_GTF="$GENOME_DIR/SkHd3_20251106_BRAKER_annot.gtf"
THREADS=${THREADS:-14}

########################################
# PREP WORKDIRS
########################################
mkdir -p "$WORKDIR/stringtie" \
  "$RNA_DIR/raw" \
  "$RNA_DIR/fastp" \
  "$RNA_DIR/bam" \
  "$GENOME_DIR/star_index"

########################################
# COLLECT RUN LIST
########################################
mapfile -t RUN_TABLE < <(
  awk 'BEGIN{FS=OFS="\t"} $1 ~ /^#/{next} toupper($2)=="TRUE"{gsub(/\r/,"",$0); print $6,$5,$3}' "$SOURCES_TSV"
)

if [[ ${#RUN_TABLE[@]} -eq 0 ]]; then
  echo "[ERROR] No samples flagged with Use=TRUE in $SOURCES_TSV" >&2
  exit 1
fi

echo "[INFO] Using ${#RUN_TABLE[@]} runs:"
printf '  - %s\n' "${RUN_TABLE[@]}"

########################################
# BUILD STAR INDICES PER READ LENGTH
########################################
ulimit -n 65536
mapfile -t READ_LENGTHS < <(awk 'BEGIN{FS="\t"} $1 ~ /^#/{next} toupper($2)=="TRUE"{gsub(/\r/,"",$5); print $5}' "$SOURCES_TSV" | sort -nu)
for rl in "${READ_LENGTHS[@]}"; do
  if [[ ! $rl =~ ^[0-9]+$ ]]; then
    echo "[WARN] Skipping non-numeric read length entry: $rl" >&2
    continue
  fi
  overhang=$((rl - 1))
  idx="$GENOME_DIR/star_index/$overhang"

  if [[ -s "$idx/SAindex" ]]; then
    echo "[INFO] STAR index for read length $rl exists at $idx"
    continue
  fi

  echo "[INFO] Building STAR index for read length $rl at $idx"
  mkdir -p "$idx"
  STAR \
    --runThreadN "$THREADS" \
    --runMode genomeGenerate \
    --genomeDir "$idx" \
    --genomeFastaFiles "$GENOME_FASTA" \
    --sjdbGTFfile "$GENOME_GTF" \
    --sjdbOverhang "$overhang" \
    --genomeSAindexNbases 12
done

########################################
# PIPELINE PER RUN
########################################
for row in "${RUN_TABLE[@]}"; do
  IFS=$'\t' read -r run rl strand <<< "$row"
  if [[ ! $rl =~ ^[0-9]+$ ]]; then
    echo "[WARN] Skipping $run due to non-numeric read length: $rl" >&2
    continue
  fi
  overhang=$((rl - 1))

  echo "[INFO] Processing $run (read length $rl, strand $strand)"

  sra_dir="$RNA_DIR/raw/$run"
  sra_file="$sra_dir/$run.sra"
  r1_raw="$RNA_DIR/raw/${run}_1.fastq.gz"
  r2_raw="$RNA_DIR/raw/${run}_2.fastq.gz"

  # Download and convert SRA to gzipped FASTQ
  if [[ ! -s "$r1_raw" || ! -s "$r2_raw" ]]; then
    echo "[INFO] Downloading $run to $RNA_DIR/raw"
    prefetch -O "$RNA_DIR/raw" "$run"
    echo "[INFO] Converting $run to FASTQ and compressing with pigz"
    fasterq-dump --threads "$THREADS" --split-files --outdir "$RNA_DIR/raw" "$sra_file"
    pigz -p "$THREADS" -f "$RNA_DIR/raw/${run}"_*.fastq
  else
    echo "[INFO] FASTQ files present for $run"
  fi

  # fastp trimming/QC
  r1_fp="$RNA_DIR/fastp/${run}_1.fastq.gz"
  r2_fp="$RNA_DIR/fastp/${run}_2.fastq.gz"
  if [[ ! -s "$r1_fp" || ! -s "$r2_fp" ]]; then
    echo "[INFO] Running fastp for $run"
    fastp \
      -w "$THREADS" \
      -i "$r1_raw" -I "$r2_raw" \
      -o "$r1_fp" -O "$r2_fp" \
      --detect_adapter_for_pe \
      --cut_tail \
      --cut_front \
      --trim_poly_x \
      --cut_mean_quality 20 \
      --length_required 100 \
      --average_qual 30 \
      --html "$RNA_DIR/fastp/${run}.html" \
      --json "$RNA_DIR/fastp/${run}.json"
  else
    echo "[INFO] fastp outputs present for $run"
  fi

  # STAR alignment
  bam="$RNA_DIR/bam/${run}.bam"
  if [[ ! -s "$bam" ]]; then
    echo "[INFO] Running STAR for $run"
    prefix="$RNA_DIR/bam/${run}."
    STAR \
      --runThreadN "$THREADS" \
      --genomeDir "$GENOME_DIR/star_index/$overhang" \
      --readFilesIn "$r1_fp" "$r2_fp" \
      --readFilesCommand zcat \
      --outFileNamePrefix "$prefix" \
      --outSAMtype BAM SortedByCoordinate \
      --outSAMstrandField intronMotif  \
      --alignIntronMax 50000  \
      --alignMatesGapMax 50000 \
      --outFilterMismatchNoverLmax 0.04 \
      --twopassMode Basic
    mv "${prefix}Aligned.sortedByCoord.out.bam" "$bam"
    samtools index -@ "$THREADS" "$bam"
  else
    echo "[INFO] BAM present for $run"
  fi

  # StringTie assembly
  gtf="$WORKDIR/stringtie/${run}.gtf"
  if [[ ! -s "$gtf" ]]; then
    echo "[INFO] Assembling transcripts for $run"
    strand_args=()
    if [[ $strand == "RF" ]]; then
      strand_args=(--rf)
    elif [[ $strand == "FR" ]]; then
      strand_args=(--fr)
    fi

    stringtie "$bam" -p "$THREADS" -o "$gtf" -l "$run" "${strand_args[@]}"
  else
    echo "[INFO] StringTie output present for $run"
  fi
done

echo "[INFO] Pipeline complete. Outputs:"
echo "  BAMs     -> $RNA_DIR/bam"
echo "  fastp    -> $RNA_DIR/fastp"
echo "  assemblies -> $WORKDIR/stringtie"

stringtie -p 14 --merge $WORKDIR/stringtie/*.gtf -o $WORKDIR/SkHd3_stringtie_merged.gtf