#!/bin/bash
#SBATCH --partition=htc
#SBATCH --job-name=peaks2utr
#SBATCH --mem=60G
#SBATCH --cpus-per-task=64
#SBATCH --time=23:59:00 
#SBATCH --output=/gpfs/data/gpfs0/vasiliy.zubarev/Sponge/Analysis/2025_04_03_CellRanger_peaks2utr_annotupdate/peaks2utr/peaks2utr1.log
#SBATCH --error=/gpfs/data/gpfs0/vasiliy.zubarev/Sponge/Analysis/2025_04_03_CellRanger_peaks2utr_annotupdate/peaks2utr/peaks2utr1.err

source activate /beegfs/home/vasiliy.zubarev/software/peaks2utr/

peaks2utr \
	--max-distance 200 \
	--extend-utr \
	--no-strand-overlap \
	--processors 64 \
	--output ./iter1_bob1/SKOL_HDuj_2_BRAKER_peaks2utr_iter1.gff \
	/gpfs/data/gpfs0/vasiliy.zubarev/Sponge/Analysis/2025_04_03_CellRanger_peaks2utr_annotupdate/peaks2utr/Braker_compleasm_PASA_AGAT.gtf \
	/gpfs/data/gpfs0/vasiliy.zubarev/Sponge/Analysis/2025_04_03_CellRanger_peaks2utr_annotupdate/CellRanger/Bob1/outs/possorted_genome_bam.bam
