#!/bin/bash
#SBATCH --partition=htc
#SBATCH --job-name=samtools
#SBATCH --mem=15G
#SBATCH --cpus-per-task=32
#SBATCH --time=1:00:00 
#SBATCH --output=/gpfs/data/gpfs0/vasiliy.zubarev/Sponge/Analysis/2024_12_02_RNAseq_filtering/samtools.log
#SBATCH --error=/gpfs/data/gpfs0/vasiliy.zubarev/Sponge/Analysis/2024_12_02_RNAseq_filtering/samtools.err


INDIR=/gpfs/data/gpfs0/vasiliy.zubarev/Sponge/Analysis/2024_12_02_RNAseq_filtering/mapped_star_iter2/
OUTDIR=/gpfs/data/gpfs0/vasiliy.zubarev/Sponge/Analysis/2024_12_02_RNAseq_filtering/bams/
INDEX=/gpfs/data/gpfs0/vasiliy.zubarev/Sponge/Analysis/2024_12_02_RNAseq_filtering/star_index_gtf_iter2/

THREADS=32

source activate /beegfs/home/vasiliy.zubarev/software/qc_trim_map
cd ${OUTDIR}

sample_description=`cat /gpfs/data/gpfs0/vasiliy.zubarev/Sponge/Data/RNA-seq/RNAseq_sample_list.txt | grep -v '#' | sed 's/\t/_/g' | head -n $SLURM_ARRAY_TASK_ID | tail -n 1`
sample_basename=`echo $sample_description | cut -f2,3,4,5,6 -d '_'`

samtools view -@ ${THREADS} --bam -F 4 ${INDIR}/${sample_basename}/Aligned.out.sam | \
samtools sort -@ ${THREADS} --output-fmt BAM --write-index -o ${sample_basename}_sorted_tmp.bam

samtools view -@ ${THREADS} --min-MQ 30 --bam ${sample_basename}_sorted_tmp.bam -o ${sample_basename}_filtered_sorted.bam
samtools index ${sample_basename}_filtered_sorted.bam

rm ${sample_basename}_sorted_tmp.bam

