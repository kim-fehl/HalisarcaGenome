#!/bin/bash
#SBATCH --partition=compute
#SBATCH --job-name=tRNAscan
#SBATCH --mem=50G
#SBATCH --cpus-per-task=24
#SBATCH --time=10:00:00 
#SBATCH --output=/gpfs/khrameeva/Halisarca_analysis/2025_11_14_annotation/RNAs/trnascan.log
#SBATCH --error=/gpfs/khrameeva/Halisarca_analysis/2025_11_14_annotation/RNAs/trnascan.err

source ~/software/miniconda3/bin/activate /home/khrameeva/software/barrnap
tRNAscan-SE -E -y -d \
		-o /gpfs/khrameeva/Halisarca_analysis/2025_11_14_annotation/RNAs/HDuj_tRNAscan.txt \
		--gff /gpfs/khrameeva/Halisarca_analysis/2025_11_14_annotation/RNAs/HDuj_tRNAscan.gff \
		--thread 24 \
		/gpfs/khrameeva/Halisarca_analysis/2025_12_18_Assembly_finalizing/finalized/SkHd3_genome_nuclear_mito.fasta
