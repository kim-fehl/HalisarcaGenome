#!/bin/bash
#SBATCH --partition=compute
#SBATCH --job-name=STAR
#SBATCH --mem=30G
#SBATCH --cpus-per-task=24
#SBATCH --time=10:00:00 
#SBATCH --output=/gpfs/khrameeva/Halisarca_analysis/2025_11_14_annotation/RNAseq_mapping/scripts_SkHd3_nextpolish/map_iter2_aggr.log
#SBATCH --error=/gpfs/khrameeva/Halisarca_analysis/2025_11_14_annotation/RNAseq_mapping/scripts_SkHd3_nextpolish/map_iter2_aggr.err

#Short single-end RNA-seq
INDIR=/gpfs/khrameeva/Data/Halisarca_RNA/trimmed_for_annotation/IDB_aggr/
INDEX=/gpfs/khrameeva/Halisarca_analysis/2025_11_14_annotation/RNAseq_mapping/map_SkHd3_nextpolish/index/iter2_SJ/len_51/
OUTDIR=/gpfs/khrameeva/Halisarca_analysis/2025_11_14_annotation/RNAseq_mapping/map_SkHd3_nextpolish/map_iter2/IDB_aggr/
THREADS=24

source ~/software/miniconda3/bin/activate ~/software/bio_basics

#head -n $SLURM_ARRAY_TASK_ID
file=`ls ${INDIR} | grep SE50 | head -n $SLURM_ARRAY_TASK_ID | tail -n 1`

STAR --runThreadN ${THREADS} \
	--genomeDir ${INDEX} \
	--readFilesIn ${INDIR}/${file} \
	--outFileNamePrefix ${OUTDIR}/${file}/ \
	--alignIntronMax 50000 \
	--outSAMmultNmax 2 \
	--outSJfilterCountUniqueMin 20 10 10 10 \
	--outSJfilterCountTotalMin 30 15 15 15 \
	--outSJfilterReads Unique \
	--readFilesCommand zcat \
	--outSAMstrandField intronMotif

samtools view -@ ${THREADS} -F 4 -Sb ${OUTDIR}/${file}/Aligned.out.sam -t /gpfs/khrameeva/Halisarca_analysis/2025_11_14_annotation/RNAseq_mapping/genome_nextpolish_scaffolds.fasta.fai | \
samtools sort -@ ${THREADS} -o ${OUTDIR}/${file}/Aligned_sorted_tmp.bam

samtools view -@ ${THREADS} -q 30 -b ${OUTDIR}/${file}/Aligned_sorted_tmp.bam -o ${OUTDIR}/${file}/Aligned_sorted_mapq30.bam
samtools index ${OUTDIR}/${file}/Aligned_sorted_mapq30.bam

rm ${OUTDIR}/${file}/Aligned_sorted_tmp.bam
rm ${OUTDIR}/${file}/Aligned.out.sam
