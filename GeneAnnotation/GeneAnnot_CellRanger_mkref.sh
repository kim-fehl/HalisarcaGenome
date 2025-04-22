#!/bin/bash
#SBATCH --partition=htc
#SBATCH --job-name=CellRanger
#SBATCH --mem=32G
#SBATCH --cpus-per-task=32
#SBATCH --time=10:00:00 
#SBATCH --output=/gpfs/data/gpfs0/vasiliy.zubarev/Sponge/Analysis/2025_04_03_CellRanger_peaks2utr_annotupdate/CellRanger/mkref.out
#SBATCH --error=/gpfs/data/gpfs0/vasiliy.zubarev/Sponge/Analysis/2025_04_03_CellRanger_peaks2utr_annotupdate/CellRanger/mkref.err

export PATH=${PATH}:~/software/cellranger-9.0.1/

cellranger mkref --genome SKOL_HDuj_2_iter1 \
		--fasta /gpfs/data/gpfs0/vasiliy.zubarev/Sponge/Results/Genome/SKOL_HDuj_2_larger3k.fasta \
		--genes /gpfs/data/gpfs0/vasiliy.zubarev/Sponge/Results/Genome/Braker_compleasm_PASA_AGAT.gtf \
		--nthreads 32 \
		--memgb 32
