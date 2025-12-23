#!/bin/bash
#SBATCH --ntasks=1
#SBATCH --job-name=mask_the_genomes
#SBATCH --output=logs/log.%x.job_%j
#SBATCH --cpus-per-task=32
#SBATCH --time=04:00:00
#SBATCH --mem=50G

export SIF=$HOME/lab/gpfs/sif_containers
export MAIN_DIR=$HOME/halisarca_genome_project

## Divide the refined consensus library of the repeats

cat $MAIN_DIR/te_trimming_results/TEtrimmer_consensus_merged.fasta | seqkit fx2tab | grep -v "Unknown" | seqkit tab2fx > $MAIN_DIR/2025_04_10_TEtrimmer_consensus_library.known.fasta
cat $MAIN_DIR/te_trimming_results/TEtrimmer_consensus_merged.fasta | seqkit fx2tab | grep "Unknown" | seqkit tab2fx > $MAIN_DIR/2025_04_10_TEtrimmer_consensus_library.Unknown.fasta

cat $MAIN_DIR/reclassified_with_TE_class_key_value.txt | awk -F '\t' '{print $2}' > $MAIN_DIR/only_headers.txt

awk 'NR == FNR { o[n++] = $0; next } /^>/ && i < n { $0 = ">" o[i++] } 1' $MAIN_DIR/only_headers.txt $MAIN_DIR/2025_04_10_TEtrimmer_consensus_library.Unknown.fasta > $MAIN_DIR/2025_10_21_TE_trimmer_consensus_library.Unknown_Reheadered.fasta

cat $MAIN_DIR/2025_10_21_TE_trimmer_consensus_library.Unknown_Reheadered.fasta | seqkit grep -r -p "#Unknown" > $MAIN_DIR/2025_10_21_TEtrimmer_consensus_library.Unknown.fasta

cat $MAIN_DIR/2025_10_21_TE_trimmer_consensus_library.Unknown_Reheadered.fasta | seqkit grep -v -r -p "#Unknown" > $MAIN_DIR/2025_10_21_TEtrimmer_consensus_library.newly_known.fasta

cat $MAIN_DIR/2025_04_10_TEtrimmer_consensus_library.known.fasta $MAIN_DIR/2025_10_21_TEtrimmer_consensus_library.newly_known.fasta > $MAIN_DIR/2025_10_21_TEtrimmer_consensus_library.known.fasta

mkdir -p $MAIN_DIR/01_simple_out \
 	 $MAIN_DIR/02_known_out \
 	 $MAIN_DIR/03_unknown_out

# ## Round 1: mask only simple repeats
apptainer run $SIF/tetools_latest.sif \
 	RepeatMasker -pa 32 -a -e ncbi \
 	-dir $MAIN_DIR/01_simple_out \
 	-noint -xsmall $MAIN_DIR/genome_nextpolish_scaffolds.fasta 2>&1 | tee $MAIN_DIR/logs/01_simplemask.log

# ## Round 1: rename the outputs
rename fasta simple_mask $MAIN_DIR/01_simple_out/genome_nextpolish_scaffolds*
rename .masked .masked.fasta $MAIN_DIR/01_simple_out/genome_nextpolish_scaffolds*

# ## Round 2: mask the genome sourced from a previous step using the set of known repeat elements, sourced from RepeatModeler and refined by TEtrimmer
apptainer run $SIF/tetools_latest.sif \
         RepeatMasker -pa 32 -a -e ncbi \
 	-dir $MAIN_DIR/02_known_out -nolow \
         -lib $MAIN_DIR/after_review_results/2025_10_21_TEtrimmer_consensus_library.known.fasta \
         $MAIN_DIR/01_simple_out/genome_nextpolish_scaffolds.simple_mask.masked.fasta 2>&1 | tee $MAIN_DIR/logs/02_knownmask.log

# ## Round 2: rename outputs
rename simple_mask.masked.fasta known_mask $MAIN_DIR/02_known_out/genome_nextpolish_scaffolds*
rename .masked .masked.fasta $MAIN_DIR/02_known_out/genome_nextpolish_scaffolds*

# ## Round 3: mask the genome sourced from a previous step using the set of unknown repeat elements, sourced from RepeatModeler and refined by TEtrimmer

apptainer run $SIF/tetools_latest.sif \
         RepeatMasker -pa 32 -a -e ncbi \
 	-dir $MAIN_DIR/03_unknown -nolow \
         -lib $MAIN_DIR/after_review_results/2025_10_21_TEtrimmer_consensus_library.Unknown.fasta \
         $MAIN_DIR/02_known_out/genome_nextpolish_scaffolds.known_mask.masked.fasta 2>&1 | tee $MAIN_DIR/logs/03_unknownmask.log

# # Round 3: rename outputs
rename known_mask.masked.fasta unknown_mask $MAIN_DIR/03_unknown/genome_nextpolish_scaffolds*
rename .masked .masked.fasta $MAIN_DIR/03_unknown/genome_nextpolish_scaffolds*

mkdir -p $MAIN_DIR/04_full_out

cat $MAIN_DIR/01_simple_out/genome_nextpolish_scaffolds.simple_mask.cat.gz \
 	$MAIN_DIR/02_known_out/genome_nextpolish_scaffolds.known_mask.cat.gz \
 	$MAIN_DIR/03_unknown/genome_nextpolish_scaffolds.unknown_mask.cat.gz \
 	> $MAIN_DIR/04_full_out/genome_nextpolish_scaffolds.full_mask.cat.gz

cat $MAIN_DIR/01_simple_out/genome_nextpolish_scaffolds.simple_mask.out \
 	<(cat $MAIN_DIR/02_known_out/genome_nextpolish_scaffolds.known_mask.out | tail -n +4) \
 	<(cat $MAIN_DIR/03_unknown/genome_nextpolish_scaffolds.unknown_mask.out | tail -n +4) \
 	> $MAIN_DIR/04_full_out/genome_nextpolish_scaffolds.full_mask.out

cat $MAIN_DIR/01_simple_out/genome_nextpolish_scaffolds.simple_mask.out > $MAIN_DIR/04_full_out/genome_nextpolish_scaffolds.simple_mask.out

cat <(cat $MAIN_DIR/02_known_out/genome_nextpolish_scaffolds.known_mask.out | tail -n +4) \
 	<(cat $MAIN_DIR/03_unknown/genome_nextpolish_scaffolds.unknown_mask.out | tail -n +4) \
 	> $MAIN_DIR/04_full_out/genome_nextpolish_scaffolds.complex_mask.out

cat $MAIN_DIR/01_simple_out/genome_nextpolish_scaffolds.simple_mask.align \
 	$MAIN_DIR/02_known_out/genome_nextpolish_scaffolds.known_mask.align \
 	$MAIN_DIR/03_unknown/genome_nextpolish_scaffolds.unknown_mask.align \
 	> $MAIN_DIR/04_full_out/genome_nextpolish_scaffolds.full_mask.align

 apptainer run $SIF/tetools_latest.sif \
         ProcessRepeats -a -species genome_nextpolish_scaffolds \
 	$MAIN_DIR/04_full_out/genome_nextpolish_scaffolds.full_mask.cat.gz \
 	2>&1 | tee $MAIN_DIR/logs/04_fullmask.log

# use Dr. Daren Card's custom script to convert .out to .gff3
$HOME/packages/GenomeAnnotation/rmOutToGFF3custom \
	-o $MAIN_DIR/04_full_out/genome_nextpolish_scaffolds.full_mask.out \
	> $MAIN_DIR/04_full_out/genome_nextpolish_scaffolds.full_mask.gff3

$HOME/packages/GenomeAnnotation/rmOutToGFF3custom \
	-o $MAIN_DIR/04_full_out/genome_nextpolish_scaffolds.simple_mask.out \
	> $MAIN_DIR/04_full_out/genome_nextpolish_scaffolds.simple_mask.gff3

rmOutToGFF3custom \
	-o $MAIN_DIR/04_full_out/genome_nextpolish_scaffolds.complex_mask.out \
	> $MAIN_DIR/04_full_out/genome_nextpolish_scaffolds.complex_mask.gff3

# Calculate TE divergence 

apptainer run $SIF/tetools_latest.sif \
	calcDivergenceFromAlign.pl \
	-s $MAIN_DIR/after_review_results/genome_nextpolish_scaffolds.divsum \
	$MAIN_DIR/04_full_out/genome_nextpolish_scaffolds.full_mask.align
