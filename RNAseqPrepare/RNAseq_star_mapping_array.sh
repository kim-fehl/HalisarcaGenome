#!/bin/bash
#SBATCH --partition=htc
#SBATCH --job-name=star_mapping
#SBATCH --mem=30G
#SBATCH --cpus-per-task=32
#SBATCH --time=10:00:00 
#SBATCH --output=/gpfs/data/gpfs0/vasiliy.zubarev/Sponge/Analysis/2024_12_02_RNAseq_filtering/mapping.log
#SBATCH --error=/gpfs/data/gpfs0/vasiliy.zubarev/Sponge/Analysis/2024_12_02_RNAseq_filtering/mapping.err


INDIR=/gpfs/data/gpfs0/vasiliy.zubarev/Sponge/Analysis/2024_12_02_RNAseq_filtering/trimmed/
OUTDIR=/gpfs/data/gpfs0/vasiliy.zubarev/Sponge/Analysis/2024_12_02_RNAseq_filtering/mapped_star_iter2/
INDEX=/gpfs/data/gpfs0/vasiliy.zubarev/Sponge/Analysis/2024_12_02_RNAseq_filtering/star_index_gtf_iter2/

THREADS=32

source activate /beegfs/home/vasiliy.zubarev/software/qc_trim_map
cd ${OUTDIR}

#Make index, iter1:
#STAR --runThreadN ${THREADS} \
#	--runMode genomeGenerate \
#	--genomeDir /gpfs/data/gpfs0/vasiliy.zubarev/Sponge/Analysis/2024_12_02_RNAseq_filtering/star_index_gtf_iter1/ \
#	--genomeFastaFiles /gpfs/data/gpfs0/vasiliy.zubarev/Sponge/Analysis/2024_12_02_RNAseq_filtering/star_index_gtf_iter1/SKOL_HDuj_2_larger3k.fasta \
#	--sjdbGTFfile /gpfs/data/gpfs0/vasiliy.zubarev/Sponge/Analysis/2024_12_02_RNAseq_filtering/star_index_gtf_iter1/SKOL_HDuj_larger3k_flo_lifted_cleaned_agat.gtf \
#	--sjdbOverhang 250 \
#	--genomeSAindexNbases 13

#Make index, iter2:
#STAR --runThreadN ${THREADS} \
#	--runMode genomeGenerate \
#	--genomeDir /gpfs/data/gpfs0/vasiliy.zubarev/Sponge/Analysis/2024_12_02_RNAseq_filtering/star_index_gtf_iter2/ \
#	--genomeFastaFiles /gpfs/data/gpfs0/vasiliy.zubarev/Sponge/Analysis/2024_12_02_RNAseq_filtering/star_index_gtf_iter2/SKOL_HDuj_2_larger3k.fasta \
#	--sjdbGTFfile /gpfs/data/gpfs0/vasiliy.zubarev/Sponge/Analysis/2024_12_02_RNAseq_filtering/star_index_gtf_iter2/SKOL_HDuj_larger3k_flo_lifted_cleaned_agat.gtf \
#	--sjdbFileChrStartEnd /gpfs/data/gpfs0/vasiliy.zubarev/Sponge/Analysis/2024_12_02_RNAseq_filtering/star_index_gtf_iter2/SJ_merged.tab \
#	--genomeSAindexNbases 13

sample_description=`cat /gpfs/data/gpfs0/vasiliy.zubarev/Sponge/Data/RNA-seq/RNAseq_sample_list.txt | grep -v '#' | sed 's/\t/_/g' | head -n $SLURM_ARRAY_TASK_ID | tail -n 1`
sample_basename=`echo $sample_description | cut -f2,3,4,5,6 -d '_'`

mkdir ./${sample_basename}/


#Short single-end RNA-seq

STAR --runThreadN ${THREADS} \
	--genomeDir ${INDEX} \
	--readFilesIn ${INDIR}/${sample_basename}_trimmed.fastq \
	--outFileNamePrefix ${OUTDIR}/${sample_basename}/ \
	--alignIntronMax 50000 \
	--outSAMmultNmax 2 \
	--outSJfilterCountUniqueMin 20 10 10 10 \
	--outSJfilterCountTotalMin 30 15 15 15 \
	--outSJfilterReads Unique \
	--outSAMstrandField intronMotif

#PE treated like SE

#STAR --runThreadN ${THREADS} \
#	--genomeDir ${INDEX} \
#	--readFilesIn ${INDIR}/${sample_basename}_R1_trimmed.fastq \
#	--outFileNamePrefix ${OUTDIR}/${sample_basename}/ \
#	--alignIntronMax 50000 \
#	--outSAMmultNmax 2 \
#	--outSJfilterCountUniqueMin 20 10 10 10 \
#	--outSJfilterCountTotalMin 30 15 15 15 \
#	--outSJfilterReads Unique \
#	--outSAMstrandField intronMotif

#STAR --runThreadN ${THREADS} \
#	--genomeDir ${INDEX} \
#	--readFilesIn ${INDIR}/${sample_basename}_R2_trimmed.fastq \
#	--outFileNamePrefix ${OUTDIR}/${sample_basename}/ \
#	--alignIntronMax 50000 \
#	--outSAMmultNmax 2 \
#	--outSJfilterCountUniqueMin 20 10 10 10 \
#	--outSJfilterCountTotalMin 30 15 15 15 \
#	--outSJfilterReads Unique \
#	--outSAMstrandField intronMotif


#samtools flagstat ${OUTDIR}/${sample_basename}/Aligned.out.sam > ${OUTDIR}/${sample_basename}/flagstat.txt
#samtools view -@ ${THREADS} --min-MQ 30 -c ${OUTDIR}/${sample_basename}/Aligned.out.sam -b -h > ${OUTDIR}/${sample_basename}/Aligned_filtered.bam



#Long paired RNA-seq

#STAR --runThreadN ${THREADS} \
#	--genomeDir /gpfs/data/gpfs0/vasiliy.zubarev/Sponge/Analysis/2024_12_02_RNAseq_filtering/star_index_gtf_iter1/ \
#	--readFilesIn ${INDIR}/${sample_basename}_R1_trimmed.fastq ${INDIR}/${sample_basename}_R2_trimmed.fastq \
#	--outFileNamePrefix ${OUTDIR}/${sample_basename}/ \
#	--outFilterScoreMinOverLread 0 \
#	--outFilterMatchNminOverLread 0 \
#	--outFilterMatchNmin 0 \
#	--outFilterMismatchNmax 3
