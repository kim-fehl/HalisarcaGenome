#!/bin/bash
#SBATCH --partition=compute
#SBATCH --job-name=STAR
#SBATCH --mem=30G
#SBATCH --cpus-per-task=24
#SBATCH --time=10:00:00 
#SBATCH --output=/gpfs/khrameeva/Halisarca_analysis/2025_11_14_annotation/Validation/star.log
#SBATCH --error=/gpfs/khrameeva/Halisarca_analysis/2025_11_14_annotation/Validation/star.err

#Short single-end RNA-seq
INDIR=/gpfs/khrameeva/Halisarca_analysis/2025_11_14_annotation/Validation/Test_GCA_049997455.1/
INDEX=/gpfs/khrameeva/Halisarca_analysis/2025_11_14_annotation/Validation/index/StPeter/len_151/
OUTDIR=/gpfs/khrameeva/Halisarca_analysis/2025_11_14_annotation/Validation/1_Compare_StPeter_SkHd3/
THREADS=24

source ~/software/miniconda3/bin/activate ~/software/bio_basics

#head -n $SLURM_ARRAY_TASK_ID
file=`ls ${INDIR} | grep fastq | cut -f1,2,3,4,5,6,7,8 -d '_' |sort |uniq| head -n $SLURM_ARRAY_TASK_ID | tail -n 1`

STAR --runThreadN ${THREADS} \
	--genomeDir ${INDEX} \
	--readFilesIn ${INDIR}/${file}_R1.fastq ${INDIR}/${file}_R2.fastq \
	--outFileNamePrefix ${OUTDIR}/${file}/ \
	--alignIntronMax 50000 \
	--outSAMmultNmax 2 \
	--outSJfilterCountUniqueMin 20 10 10 10 \
	--outSJfilterCountTotalMin 30 15 15 15 \
	--outSJfilterReads Unique \
	--outSAMstrandField intronMotif \
	--quantMode GeneCounts
