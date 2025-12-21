#!/bin/bash
#SBATCH --partition=compute
#SBATCH --job-name=STAR
#SBATCH --mem=30G
#SBATCH --cpus-per-task=24
#SBATCH --time=10:00:00 
#SBATCH --output=/gpfs/khrameeva/Halisarca_analysis/2025_11_14_annotation/RNAseq_mapping/scripts_SkHd3_nextpolish/index_iter1.log
#SBATCH --error=/gpfs/khrameeva/Halisarca_analysis/2025_11_14_annotation/RNAseq_mapping/scripts_SkHd3_nextpolish/index_iter1.err

OUTDIR=/gpfs/khrameeva/Halisarca_analysis/2025_11_14_annotation/RNAseq_mapping/map_SkHd3_nextpolish/
THREADS=24

source ~/software/miniconda3/bin/activate ~/software/bio_basics
cd ${OUTDIR}

#Make index, iter1:
STAR --runThreadN ${THREADS} \
	--runMode genomeGenerate \
	--genomeDir iter1_blind \
	--genomeFastaFiles /gpfs/khrameeva/Halisarca_analysis/2025_11_14_annotation/RNAseq_mapping/genome_nextpolish_scaffolds.fasta \
	--genomeSAindexNbases 13
