#!/bin/bash
#SBATCH --partition=compute
#SBATCH --job-name=fastp_trimming
#SBATCH --mem=10G
#SBATCH --cpus-per-task=16
#SBATCH --time=1:00:00 
#SBATCH --output=/gpfs/khrameeva/Data/Halisarca_RNA/filter.log
#SBATCH --error=/gpfs/khrameeva/Data/Halisarca_RNA/filter.err
source ~/software/miniconda3/bin/activate ~/software/bio_basics

INDIR=/gpfs/khrameeva/Data/Halisarca_RNA/raw_for_annotation/
OUTDIR=/gpfs/khrameeva/Data/Halisarca_RNA/trimmed_for_annotation/IDB_aggr/
REPORT=/gpfs/khrameeva/Data/Halisarca_RNA/trimmed_for_annotation/trim_reports/

#head -n $SLURM_ARRAY_TASK_ID
file=`ls ${INDIR} | grep SE50 | head -n $SLURM_ARRAY_TASK_ID | tail -n 1`

#for single-end short reads
mkdir /gpfs/data/gpfs0/vasiliy.zubarev/Sponge/Data/RNA-seq/preprocessing/fastqc_trimmed/${dataset}_${sample}_${rep}/
fastp --in1 ${INDIR}/${file} \
	--out1 ${OUTDIR}/${file} \
	--cut_tail \
	--cut_front \
	--trim_poly_x \
	--cut_mean_quality 20 \
	--length_required 40 \
	--average_qual 20 \
	--thread 16 \
	-j ${REPORT}/${file}.fastp.json \
	-h ${REPORT}/${file}.fastp.html

fastqc --outdir ${REPORT}/fastqc_trimmed/ --threads 16 \
	${OUTDIR}/${file}