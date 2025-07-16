#!/usr/bin/env bash
set -euo pipefail

##### CONSTANTS #####
# Working directories
WORKDIR=/home/lab/kim/hd/pasa
GENOME_DIR=/home/lab/kim/hd/genome
RNA_DIR=/home/lab/kim/hd/rnaseq/assemblies

# Core input files
GENOME="$GENOME_DIR/SKOL_HDuj_2_larger3k_mito_rotated.fasta"
TRANSCRIPTS="$RNA_DIR/IDB_ANU_clstr_DN_transcripts_cleandust.fna"
TRANS_GTF="$RNA_DIR/SPBU_IDB_ANU_StringTie.gtf"
INITIAL_ANNOT="$GENOME_DIR/braker_AGAT_mitoCleaned_PASA.gff3"

# PASA config 
CONFIG="$WORKDIR/pasa_hd.config"
cat > "$CONFIG" << 'EOF'
# database settings
DATABASE=HD_pasa
SERVER=localhost
PORT=3306
USER=pasa_write
PASSWORD=pasa_write_pwd

validate_alignments_in_db.dbi:--MIN_PERCENT_ALIGNED=95
validate_alignments_in_db.dbi:--MIN_AVG_PER_ID=90

# minimum overlap length 
subcluster_builder.dbi:-m=50
cDNA_annotation_comparer.dbi:--MAX_UTR_EXONS=3
EOF

##### UTILITY FUNCTION #####
run_pasa() {
  local extra_args=("$@")
  "${PASAHOME}/Launch_PASA_pipeline.pl" \
    -c "$CONFIG" \
    --run --create \
    --CPU $(nproc) \
    --ALIGNERS gmap,minimap2 \
    --genome "$GENOME" \
    --transcripts "$TRANSCRIPTS" \
    --trans_gtf "$TRANS_GTF" \
    "${extra_args[@]}"
}

##### STEP 1: INITIAL ALIGNMENT #####
echo "[INFO] Running initial alignment..."
run_pasa

##### STEP 2–N: ITERATIVE ANNOTATION UPDATES #####
annot_gff="$INITIAL_ANNOT"
for round in {1..3}; do
  echo "[INFO] Annotation update round $round using $annot_gff"
  run_pasa \
    --annot_compare \
    --MAX_INTRON_LENGTH 30000 \
    --gene_overlap 50.0 \
    -L --annots "$annot_gff"

  # Automatically pick the freshest GFF3 output for the next round
  annot_gff=$(ls -t "$WORKDIR"/*post_PASA_updates.*.gff3 | head -n1)
  echo "[INFO] Round $round produced new annotation: $annot_gff"
done
