#!/bin/bash
#SBATCH --partition=compute
#SBATCH --job-name=fastp_trimming
#SBATCH --mem=20G
#SBATCH --cpus-per-task=16
#SBATCH --time=2:00:00 
#SBATCH --output=/gpfs/khrameeva/Data/Halisarca_HiC/filter.log
#SBATCH --error=/gpfs/khrameeva/Data/Halisarca_HiC/filter.err

INDIR=/gpfs/khrameeva/Data/Halisarca_HiC/batch1_untrimmed/
OUTDIR=/gpfs/khrameeva/Data/Halisarca_HiC/batch1/
#head -n $SLURM_ARRAY_TASK_ID
sample_description=`ls ${INDIR} | cut -f1,2,3 -d '_' | sort | uniq | head -n $SLURM_ARRAY_TASK_ID | tail -n 1`

source ~/software/miniconda3/bin/activate ~/software/bio_basics

#paired-end long mode

fastp --in1 ${INDIR}/${sample_description}_R1_001.fastq.gz \
	--in2 ${INDIR}/${sample_description}_R2_001.fastq.gz \
	--out1 ${OUTDIR}/${sample_description}_R1.fastq.gz \
	--out2 ${OUTDIR}/${sample_description}_R2.fastq.gz \
	--detect_adapter_for_pe \
	--cut_tail \
	--cut_front \
	--trim_poly_x \
	--cut_mean_quality 20 \
	--length_required 70 \
	--average_qual 25 \
	--json ${INDIR}/${sample_description}_fastp.json \
	--html ${INDIR}/${sample_description}_fastp.html \
	--thread 16
