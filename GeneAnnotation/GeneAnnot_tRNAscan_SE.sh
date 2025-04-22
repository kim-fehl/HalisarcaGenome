#!/bin/bash
#SBATCH --partition=htc
#SBATCH --job-name=tRNAscan
#SBATCH --mem=60G
#SBATCH --cpus-per-task=32
#SBATCH --time=10:00:00 
#SBATCH --output=/gpfs/data/gpfs0/vasiliy.zubarev/Sponge/Analysis/2025_04_10_tRNAscan_SE/trnascan.log
#SBATCH --error=/gpfs/data/gpfs0/vasiliy.zubarev/Sponge/Analysis/2025_04_10_tRNAscan_SE/trnascan.err

source activate /beegfs/home/vasiliy.zubarev/software/tRNAscan-SE
tRNAscan-SE -E -y -d \
		-o /gpfs/data/gpfs0/vasiliy.zubarev/Sponge/Analysis/2025_04_10_tRNAscan_SE/HDuj_tRNAscan.txt \
		--gff /gpfs/data/gpfs0/vasiliy.zubarev/Sponge/Analysis/2025_04_10_tRNAscan_SE/HDuj_tRNAscan.gff \
		--thread 32 \
		/gpfs/data/gpfs0/vasiliy.zubarev/Sponge/Results/Genome/SKOL_HDuj_2_larger3k.fasta

