#!/bin/bash
#SBATCH --partition=htc
#SBATCH --job-name=barRNAp
#SBATCH --mem=32G
#SBATCH --cpus-per-task=32
#SBATCH --time=10:00:00 
#SBATCH --output=/gpfs/data/gpfs0/vasiliy.zubarev/Sponge/Analysis/2025_04_16_barrnap/barrnap.log
#SBATCH --error=/gpfs/data/gpfs0/vasiliy.zubarev/Sponge/Analysis/2025_04_16_barrnap/barrnap.err

source activate /beegfs/home/vasiliy.zubarev/software/barrnap/
barrnap --kingdom euk \
	--threads 32 \
	--outseq /gpfs/data/gpfs0/vasiliy.zubarev/Sponge/Analysis/2025_04_16_barrnap/SKOL_HDuj_2_rRNA.fasta \
	/gpfs/data/gpfs0/vasiliy.zubarev/Sponge/Results/Genome/SKOL_HDuj_2_larger3k.fasta
