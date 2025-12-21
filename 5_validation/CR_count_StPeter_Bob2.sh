#!/bin/bash
#SBATCH --partition=htc
#SBATCH --job-name=CellRanger
#SBATCH --mem=40G
#SBATCH --cpus-per-task=40
#SBATCH --time=23:00:00 
#SBATCH --output=/gpfs/data/gpfs0/vasiliy.zubarev/Sponge/Analysis/2025_12_11_validation/CellRanger/count_StPeter_bob2.out
#SBATCH --error=/gpfs/data/gpfs0/vasiliy.zubarev/Sponge/Analysis/2025_12_11_validation/CellRanger/count_StPeter_bob2.err

export PATH=${PATH}:/beegfs/home/vasiliy.zubarev/software/cellranger-9.0.1
WD=/gpfs/data/gpfs0/vasiliy.zubarev/Sponge/Analysis/2025_12_11_validation/CellRanger/count/GCA_049997455.1_Bob2/
SAMPLE=GCA_049997455_Bob2

cd ${WD}
cellranger count --transcriptome /gpfs/data/gpfs0/vasiliy.zubarev/Sponge/Analysis/2025_12_11_validation/CellRanger/StPeter_Hd/ \
		--fastqs /gpfs/data/gpfs0/vasiliy.zubarev/Sponge/Data/scRNAseq_for_comparisons/ \
		--sample ${SAMPLE} \
		--create-bam false \
		--localcores 40 \
		--localmem 40 \
		--id GCA_049997455_Bob2