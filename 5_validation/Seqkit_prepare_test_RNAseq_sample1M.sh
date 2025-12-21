#!/bin/bash
#SBATCH --partition=compute
#SBATCH --job-name=seqkit_sample
#SBATCH --mem=10G
#SBATCH --cpus-per-task=16
#SBATCH --time=1:00:00 
#SBATCH --output=/gpfs/khrameeva/Halisarca_analysis/2025_11_14_annotation/Validation/seqkit.log
#SBATCH --error=/gpfs/khrameeva/Halisarca_analysis/2025_11_14_annotation/Validation/seqkit.err
source ~/software/miniconda3/bin/activate ~/software/bio_basics

INDIR=/gpfs/khrameeva/Data/Halisarca_RNA/trimmed_for_annotation/SPB_regen/
OUTDIR=/gpfs/khrameeva/Halisarca_analysis/2025_11_14_annotation/Validation/Test_RNAseq/
export SEQKIT_THREADS=16

#head -n $SLURM_ARRAY_TASK_ID
file=`ls ${INDIR} | grep SPB_regen | cut -f1,2,3,4,5 -d '_' | sort | uniq | head -n $SLURM_ARRAY_TASK_ID | tail -n 1`

seqkit sample -p 0.2 -s 2025 ${INDIR}/${file}_R1.fastq.gz | seqkit sample -n 1000000 -s 2025 > ${OUTDIR}/${file}_sample1M_R1.fastq.gz
seqkit sample -p 0.2 -s 2025 ${INDIR}/${file}_R2.fastq.gz | seqkit sample -n 1000000 -s 2025 > ${OUTDIR}/${file}_sample1M_R2.fastq.gz
