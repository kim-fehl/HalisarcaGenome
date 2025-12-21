#!/bin/bash
#SBATCH --partition=htc
#SBATCH --job-name=CellRanger
#SBATCH --mem=32G
#SBATCH --cpus-per-task=32
#SBATCH --time=10:00:00 
#SBATCH --output=/gpfs/data/gpfs0/vasiliy.zubarev/Sponge/Analysis/2025_12_11_validation/CellRanger/mkref.out
#SBATCH --error=/gpfs/data/gpfs0/vasiliy.zubarev/Sponge/Analysis/2025_12_11_validation/CellRanger/mkref.err

export PATH=${PATH}:~/software/cellranger-9.0.1/

cellranger mkref --genome SkHd3 \
		--fasta /gpfs/data/gpfs0/vasiliy.zubarev/Sponge/Analysis/2025_12_11_validation/CellRanger/SkHd3_genome_nuclear_mito.fasta \
		--genes /gpfs/data/gpfs0/vasiliy.zubarev/Sponge/Analysis/2025_12_11_validation/CellRanger/SkHd3_genes_nuclear_mito_annot.gtf \
		--nthreads 32 \
		--memgb 32
