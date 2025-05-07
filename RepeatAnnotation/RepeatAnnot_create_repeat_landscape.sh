#!/bin/bash
#SBATCH --ntasks=1
#SBATCH --job-name=create_repeat_landscape
#SBATCH --output=logs/log.%x.job_%j
#SBATCH --cpus-per-task=32
#SBATCH --time=01:00:00
#SBATCH --mem=10G

export SIF=$HOME/lab/gpfs/sif_containers
export MAIN_DIR=$HOME/halisarca_genome_project

apptainer run $SIF/tetools_latest.sif \
	calcDivergenceFromAlign.pl \
	-s $MAIN_DIR/SKOL_HDuj_2_larger3k.divsum \
	$MAIN_DIR/04_full_out/SKOL_HDuj_2_larger3k.full_mask.align


