#!/bin/bash
#SBATCH --partition=compute
#SBATCH --job-name=STAR
#SBATCH --mem=30G
#SBATCH --cpus-per-task=24
#SBATCH --time=10:00:00 
#SBATCH --output=/gpfs/khrameeva/Halisarca_analysis/2025_11_14_annotation/Validation/index.log
#SBATCH --error=/gpfs/khrameeva/Halisarca_analysis/2025_11_14_annotation/Validation/index.log

THREADS=24
LEN=151

OUTDIR=/gpfs/khrameeva/Halisarca_analysis/2025_11_14_annotation/Validation/index/StPeter/
FASTA=/gpfs/khrameeva/Halisarca_analysis/2025_11_14_annotation/Validation/StPeter_Hd_genome_contigIDs.fasta
GFF=/gpfs/khrameeva/Halisarca_analysis/2025_11_14_annotation/Validation/StPeter_hdu_gene_models_AGAT.gtf
cd ${OUTDIR}

STAR --runThreadN ${THREADS} \
	--runMode genomeGenerate \
	--genomeDir len_${LEN} \
	--genomeFastaFiles ${FASTA} \
	--sjdbGTFfile ${GFF} \
	--sjdbOverhang ${LEN} \
	--genomeSAindexNbases 13

OUTDIR=/gpfs/khrameeva/Halisarca_analysis/2025_11_14_annotation/Validation/index/SkHd3/
FASTA=/gpfs/khrameeva/Halisarca_analysis/2025_12_18_Assembly_finalizing/finalized/SkHd3_genome_nuclear_mito.fasta
GFF=/gpfs/khrameeva/Halisarca_analysis/2025_12_18_Assembly_finalizing/finalized/total_genes_annot.gtf
cd ${OUTDIR}

STAR --runThreadN ${THREADS} \
	--runMode genomeGenerate \
	--genomeDir len_${LEN} \
	--genomeFastaFiles ${FASTA} \
	--sjdbGTFfile ${GFF} \
	--sjdbOverhang ${LEN} \
	--genomeSAindexNbases 13
