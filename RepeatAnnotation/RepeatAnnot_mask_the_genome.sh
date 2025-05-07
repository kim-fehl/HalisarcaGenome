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

mkdir -p $MAIN_DIR/01_simple_out \
	 $MAIN_DIR/02_known_out \
	 $MAIN_DIR/03_unknown_out

## Round 1: mask only simple repeats
apptainer run $SIF/tetools_latest.sif \
	RepeatMasker -pa 32 -a -e ncbi \
	-dir $MAIN_DIR/01_simple_out \
	-noint -xsmall $MAIN_DIR/data/SKOL_HDuj_2_larger3k.fasta 2>&1 | tee $MAIN_DIR/logs/01_simplemask.log

## Round 1: rename the outputs
rename fasta simple_mask $MAIN_DIR/01_simple_out/SKOL_HDuj_2_larger3k*
rename .masked .masked.fasta $MAIN_DIR/01_simple_out/SKOL_HDuj_2_larger3k*

## Round 2: mask the genome sourced from a previous step using the set of known repeat elements, sourced from RepeatModeler and refined by TEtrimmer
apptainer run $SIF/tetools_latest.sif \
        RepeatMasker -pa 32 -a -e ncbi \
	-dir $MAIN_DIR/02_known_out -nolow \
        -lib $MAIN_DIR/2025_04_10_TEtrimmer_consensus_library.known.fasta \
        $MAIN_DIR/01_simple_out/SKOL_HDuj_2_larger3k.simple_mask.masked.fasta 2>&1 | tee $MAIN_DIR/logs/02_knownmask.log

## Round 2: rename outputs
rename simple_mask.masked.fasta known_mask $MAIN_DIR/02_known_out/SKOL_HDuj_2_larger3k*
rename .masked .masked.fasta $MAIN_DIR/02_known_out/SKOL_HDuj_2_larger3k*

## Round 3: mask the genome sourced from a previous step using the set of unknown repeat elements, sourced from RepeatModeler and refined by TEtrimmer

apptainer run $SIF/tetools_latest.sif \
        RepeatMasker -pa 32 -a -e ncbi \
	-dir $MAIN_DIR/03_unknown -nolow \
        -lib $MAIN_DIR/2025_04_10_TEtrimmer_consensus_library.Unknown.fasta \
        $MAIN_DIR/02_known_out/SKOL_HDuj_2_larger3k.known_mask.masked.fasta 2>&1 | tee $MAIN_DIR/logs/03_unknownmask.log

# round 4: rename outputs
rename known_mask.masked.fasta unknown_mask $MAIN_DIR/03_unknown/SKOL_HDuj_2_larger3k*
rename .masked .masked.fasta $MAIN_DIR/03_unknown/SKOL_HDuj_2_larger3k*
