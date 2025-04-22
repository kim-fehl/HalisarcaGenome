#!/bin/bash
#SBATCH --partition=htc
#SBATCH --job-name=CellRanger
#SBATCH --mem=80G
#SBATCH --cpus-per-task=64
#SBATCH --time=23:00:00 
#SBATCH --output=/gpfs/data/gpfs0/vasiliy.zubarev/Sponge/Analysis/2025_04_03_CellRanger_peaks2utr_annotupdate/CellRanger/count_bob1.out
#SBATCH --error=/gpfs/data/gpfs0/vasiliy.zubarev/Sponge/Analysis/2025_04_03_CellRanger_peaks2utr_annotupdate/CellRanger/count_bob2.err

export PATH=${PATH}:/beegfs/home/vasiliy.zubarev/software/cellranger-9.0.1
WD=/gpfs/data/gpfs0/vasiliy.zubarev/Sponge/Analysis/2025_04_03_CellRanger_peaks2utr_annotupdate/CellRanger
SAMPLE=Bob1

cd ${WD}
cellranger count --transcriptome /gpfs/data/gpfs0/vasiliy.zubarev/Sponge/Analysis/2025_04_03_CellRanger_peaks2utr_annotupdate/CellRanger/SKOL_HDuj_2_iter1/ \
		--fastqs /gpfs/data/gpfs0/vasiliy.zubarev/Sponge/Data/scRNA-seq \
		--sample ${SAMPLE} \
		--create-bam true \
		--localcores 40 \
		--localmem 80 \
		--id ${SAMPLE}