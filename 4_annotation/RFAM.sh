#!/bin/bash
#SBATCH --partition=compute
#SBATCH --job-name=infernal
#SBATCH --mem=60G
#SBATCH --cpus-per-task=24
#SBATCH --time=10-00:00:00 
#SBATCH --output=/gpfs/khrameeva/Halisarca_analysis/2025_11_14_annotation/RNAs/infernal.log
#SBATCH --error=/gpfs/khrameeva/Halisarca_analysis/2025_11_14_annotation/RNAs/infernal.err

source ~/software/miniconda3/bin/activate /home/khrameeva/software/barrnap

GENOME=/gpfs/khrameeva/Halisarca_analysis/2025_12_18_Assembly_finalizing/finalized/SkHd3_genome_nuclear_mito.fasta
cmscan -Z 2000 --cut_ga --rfam --tblout infernal.out --fmt 2 --cpu 24 --clanin Rfam.clanin Rfam.cm $GENOME > infernal.log