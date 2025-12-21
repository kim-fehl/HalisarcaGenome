#!/bin/bash
#SBATCH --partition=htc
#SBATCH --job-name=CellRanger
#SBATCH --mem=32G
#SBATCH --cpus-per-task=32
#SBATCH --time=10:00:00 
#SBATCH --output=/gpfs/data/gpfs0/vasiliy.zubarev/Sponge/Analysis/2025_07_01_mapping_rates/StPeter_scRNAseq/mkref.out
#SBATCH --error=/gpfs/data/gpfs0/vasiliy.zubarev/Sponge/Analysis/2025_07_01_mapping_rates/StPeter_scRNAseq/mkref.err

export PATH=${PATH}:~/software/cellranger-9.0.1/

cellranger mkref --genome StPeter_Hd \
		--fasta /gpfs/data/gpfs0/vasiliy.zubarev/Sponge/Analysis/2025_04_23_compleasm/StPeter_Hd_genome_contigIDs.fasta \
		--genes /gpfs/data/gpfs0/vasiliy.zubarev/Sponge/Analysis/2025_04_23_compleasm/StPeter_hdu_gene_models_AGAT.gtf \
		--nthreads 32 \
		--memgb 32
