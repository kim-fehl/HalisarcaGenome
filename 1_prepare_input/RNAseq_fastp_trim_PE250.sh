#!/bin/bash
#SBATCH --partition=compute
#SBATCH --job-name=fastp_trimming
#SBATCH --mem=10G
#SBATCH --cpus-per-task=16
#SBATCH --time=1:00:00 
#SBATCH --output=/gpfs/khrameeva/Data/Halisarca_RNA/filter_pe250.log
#SBATCH --error=/gpfs/khrameeva/Data/Halisarca_RNA/filter_pe250.err
source ~/software/miniconda3/bin/activate ~/software/bio_basics

INDIR=/gpfs/khrameeva/Data/Halisarca_RNA/raw_for_annotation/
OUTDIR=/gpfs/khrameeva/Data/Halisarca_RNA/trimmed_for_annotation/IDB_basic/
REPORT=/gpfs/khrameeva/Data/Halisarca_RNA/trimmed_for_annotation/trim_reports/

#head -n $SLURM_ARRAY_TASK_ID
file=`ls ${INDIR} | grep PE250 | cut -f1,2,3,4,5 -d '_' | sort | uniq | head -n $SLURM_ARRAY_TASK_ID | tail -n 1`

#for paired-end long reads
fastp --in1 ${INDIR}/${file}_R1.fastq.gz \
	--in2 ${INDIR}/${file}_R2.fastq.gz \
	--out1 ${OUTDIR}/${file}_R1.fastq.gz \
	--out2 ${OUTDIR}/${file}_R2.fastq.gz \
	--detect_adapter_for_pe \
	--cut_tail \
	--cut_front \
	--trim_poly_x \
	--cut_mean_quality 20 \
	--length_required 100 \
	--average_qual 25 \
	--thread 16 \
	-j ${REPORT}/${file}.fastp.json \
	-h ${REPORT}/${file}.fastp.html

fastqc --outdir ${REPORT}/fastqc_trimmed/ --threads 16 \
	${OUTDIR}/${file}_R1.fastq.gz \
	${OUTDIR}/${file}_R2.fastq.gz