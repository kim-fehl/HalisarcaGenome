#!/bin/bash
#SBATCH --partition=compute
#SBATCH --job-name=barRNAp
#SBATCH --mem=32G
#SBATCH --cpus-per-task=24
#SBATCH --time=10:00:00 
#SBATCH --output=/gpfs/khrameeva/Halisarca_analysis/2025_11_14_annotation/RNAs/barrnap.gff
#SBATCH --error=/gpfs/khrameeva/Halisarca_analysis/2025_11_14_annotation/RNAs/barrnap.err

source ~/software/miniconda3/bin/activate /home/khrameeva/software/barrnap
barrnap --kingdom euk \
	--threads 24 \
	--outseq /gpfs/khrameeva/Halisarca_analysis/2025_11_14_annotation/RNAs/SkHd3_rRNAs.fasta \
	/gpfs/khrameeva/Halisarca_analysis/2025_12_18_Assembly_finalizing/finalized/SkHd3_genome_nuclear_mito.fasta
