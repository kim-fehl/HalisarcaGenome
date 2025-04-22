#!/bin/bash
#SBATCH --partition=htc
#SBATCH --job-name=fastp_trimming
#SBATCH --mem=10G
#SBATCH --cpus-per-task=16
#SBATCH --time=1:00:00 
#SBATCH --output=/gpfs/data/gpfs0/vasiliy.zubarev/Sponge/Analysis/2024_12_02_RNAseq_filtering/filter.log
#SBATCH --error=/gpfs/data/gpfs0/vasiliy.zubarev/Sponge/Analysis/2024_12_02_RNAseq_filtering/filter.err

INDIR=/gpfs/data/gpfs0/vasiliy.zubarev/Sponge/Data/RNA-seq/
OUTDIR=/gpfs/data/gpfs0/vasiliy.zubarev/Sponge/Analysis/2024_12_02_RNAseq_filtering/trimmed/

sample_description=`cat /gpfs/data/gpfs0/vasiliy.zubarev/Sponge/Data/RNA-seq/RNAseq_sample_list.txt | grep -v '#' | sed 's/\t/_/g' | head -n $SLURM_ARRAY_TASK_ID | tail -n 1`
sample_basename=`echo $sample_description | cut -f2,3,4,5,6 -d '_'`

source activate /beegfs/home/vasiliy.zubarev/software/qc_trim_map

#paired-end long mode

#fastp --in1 ${INDIR}/${sample_basename}.fastq.gz --interleaved_in \
#	--out1 ${OUTDIR}/${sample_basename}_R1_trimmed.fastq \
#	--out2 ${OUTDIR}/${sample_basename}_R2_trimmed.fastq \
#	--cut_tail \
#	--cut_front \
#	--trim_poly_x \
#	--cut_mean_quality 20 \
#	--length_required 100 \
#	--average_qual 30 \
#	--thread 16

#single-end short mode

fastp --in1 ${INDIR}/${sample_basename}.fastq.gz \
	--out1 ${OUTDIR}/${sample_basename}_trimmed.fastq \
	--cut_tail \
	--cut_front \
	--trim_poly_x \
	--cut_mean_quality 20 \
	--length_required 30 \
	--average_qual 30 \
	--thread 16

#paired-end, cut all after base 65 due to low quality at bases 65-100

#fastp --in1 ${INDIR}/${sample_basename}.fastq.gz --interleaved_in \
#	--out1 ${OUTDIR}/${sample_basename}_R1_trimmed.fastq \
#	--out2 ${OUTDIR}/${sample_basename}_R2_trimmed.fastq \
#	--trim_tail1 100 \
#	--trim_tail2 100 \
#	--trim_poly_x \
#	--cut_tail \
#	--cut_front \
#	--cut_mean_quality 30 \
#	--length_required 60 \
#	--average_qual 30 \
#	--thread 16

#fastp --in1 ${INDIR}/${sample_basename}.fastq.gz --interleaved_in \
#	--out1 ${OUTDIR}/${sample_basename}_R1_trimmed_tmp.fastq \
#	--out2 ${OUTDIR}/${sample_basename}_R2_trimmed_tmp.fastq \
#	--trim_tail1 100 \
#	--trim_tail2 100 \
#	--thread 16

#fastp --in1 ${OUTDIR}/${sample_basename}_R1_trimmed_tmp.fastq \
#	--in2 ${OUTDIR}/${sample_basename}_R2_trimmed_tmp.fastq \
#	--out1 ${OUTDIR}/${sample_basename}_R1_trimmed.fastq \
#	--out2 ${OUTDIR}/${sample_basename}_R2_trimmed.fastq \
#	--trim_tail1 30 \
#	--trim_tail2 30 \
#	--trim_poly_x \
#	--cut_tail \
#	--cut_front \
#	--cut_mean_quality 30 \
#	--length_required 60 \
#	--average_qual 30 \
#	--thread 16

#rm ${OUTDIR}/${sample_basename}_R1_trimmed_tmp.fastq
#rm ${OUTDIR}/${sample_basename}_R2_trimmed_tmp.fastq
