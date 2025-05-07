#!/bin/bash
#SBATCH --ntasks=1
#SBATCH --job-name=combine_mask_results
#SBATCH --output=logs/log.%x.job_%j
#SBATCH --cpus-per-task=32
#SBATCH --time=01:00:00
#SBATCH --mem=10G

export MAIN_DIR=$HOME/halisarca_genome_project
export SIF=$HOME/lab/gpfs/sif_containers

mkdir -p $MAIN_DIR/04_full_out

cat $MAIN_DIR/01_simple_out/SKOL_HDuj_2_larger3k.simple_mask.cat.gz \
	$MAIN_DIR/02_known_out/SKOL_HDuj_2_larger3k.known_mask.cat.gz \
	$MAIN_DIR/03_unknown/SKOL_HDuj_2_larger3k.unknown_mask.cat.gz \
	> $MAIN_DIR/04_full_out/SKOL_HDuj_2_larger3k.full_mask.cat.gz

cat $MAIN_DIR/01_simple_out/SKOL_HDuj_2_larger3k.simple_mask.out \
	<(cat $MAIN_DIR/02_known_out/SKOL_HDuj_2_larger3k.known_mask.out | tail -n +4) \
	<(cat $MAIN_DIR/03_unknown/SKOL_HDuj_2_larger3k.unknown_mask.out | tail -n +4) \
	> $MAIN_DIR/04_full_out/SKOL_HDuj_2_larger3k.full_mask.out

cat $MAIN_DIR/01_simple_out/SKOL_HDuj_2_larger3k.simple_mask.out > $MAIN_DIR/04_full_out/SKOL_HDuj_2_larger3k.simple_mask.out

cat <(cat $MAIN_DIR/02_known_out/SKOL_HDuj_2_larger3k.known_mask.out | tail -n +4) \
	<(cat $MAIN_DIR/03_unknown/SKOL_HDuj_2_larger3k.unknown_mask.out | tail -n +4) \
	> $MAIN_DIR/04_full_out/SKOL_HDuj_2_larger3k.complex_mask.out

cat $MAIN_DIR/01_simple_out/SKOL_HDuj_2_larger3k.simple_mask.align \
	$MAIN_DIR/02_known_out/SKOL_HDuj_2_larger3k.known_mask.align \
	$MAIN_DIR/03_unknown/SKOL_HDuj_2_larger3k.unknown_mask.align \
	> $MAIN_DIR/04_full_out/SKOL_HDuj_2_larger3k.full_mask.align

apptainer run $SIF/tetools_latest.sif \
        ProcessRepeats -a -species SKOL_HDuj_2_larger3k \
	$MAIN_DIR/04_full_out/SKOL_HDuj_2_larger3k.full_mask.cat.gz \
	2>&1 | tee $MAIN_DIR/logs/04_fullmask.log

# use Dr. Daren Card's custom script to convert .out to .gff3
rmOutToGFF3custom \
	-o $MAIN_DIR/04_full_out/SKOL_HDuj_2_larger3k.full_mask.out \
	> $MAIN_DIR/04_full_out/SKOL_HDuj_2_larger3k.full_mask.gff3

rmOutToGFF3custom \
	-o $MAIN_DIR/04_full_out/SKOL_HDuj_2_larger3k.simple_mask.out \
	> $MAIN_DIR/04_full_out/SKOL_HDuj_2_larger3k.simple_mask.gff3

rmOutToGFF3custom \
	-o $MAIN_DIR/04_full_out/SKOL_HDuj_2_larger3k.complex_mask.out \
	> $MAIN_DIR/04_full_out/SKOL_HDuj_2_larger3k.complex_mask.gff3
