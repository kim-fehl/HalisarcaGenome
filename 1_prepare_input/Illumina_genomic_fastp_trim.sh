#!/bin/bash
#SBATCH --partition=compute
#SBATCH --job-name=fastp_trimming
#SBATCH --mem=20G
#SBATCH --cpus-per-task=16
#SBATCH --time=1:00:00 
#SBATCH --output=/gpfs/khrameeva/Data/Halisarca_illumina/filter.log
#SBATCH --error=/gpfs/khrameeva/Data/Halisarca_illumina/filter.err

IN_PREFIX=/gpfs/khrameeva/Data/Halisarca_illumina/SKOL_GenomicIllumina_AdultBody_no_PE250
OUTDIR=/gpfs/khrameeva/Data/Halisarca_illumina/
sample_basename=SKOL_GenomicIllumina_AdultBody_no_PE250

source /home/khrameeva/software/miniconda3/bin/activate /home/khrameeva/software/bio_basics/

#paired-end long mode

fastp --in1 ${IN_PREFIX}_R1.fastq.gz \
	--in2 ${IN_PREFIX}_R2.fastq.gz \
	--out1 ${OUTDIR}/${sample_basename}_R1_trimmed.fastq.gz \
	--out2 ${OUTDIR}/${sample_basename}_R2_trimmed.fastq.gz \
	--detect_adapter_for_pe \
	--cut_tail \
	--cut_front \
	--trim_poly_g \
	--cut_mean_quality 20 \
	--length_required 100 \
	--average_qual 25 \
	--thread 16

cd ${OUTDIR}
fastqc ${sample_basename}_R1_trimmed.fastq.gz ${sample_basename}_R2_trimmed.fastq.gz -t 16