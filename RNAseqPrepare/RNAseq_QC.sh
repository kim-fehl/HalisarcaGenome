#!/bin/bash
#PBS -N fastqc
#PBS -l walltime=5:00:00
#PBS -l nodes=1:ppn=20
#PBS -l mem=10Gb
#PBS -e /gss/home/vasiliy.zubarev/RNAseq/FASTQC/$PBS_JOBNAME.$PBS_JOBID.err   
#PBS -o /gss/home/vasiliy.zubarev/RNAseq/FASTQC/$PBS_JOBNAME.$PBS_JOBID.out   
#PBS -d /gss/home/vasiliy.zubarev/RNAseq/FASTQC/

source activate /gss/home/vasiliy.zubarev/software/qc_trim_align

fastqc -o /gss/home/vasiliy.zubarev/RNAseq/FASTQC/ \
	/gss/home/vasiliy.zubarev/RNAseq/IDB* \
	/gss/home/vasiliy.zubarev/RNAseq/AUSTR* \
	-t 20

multiqc /gss/home/vasiliy.zubarev/RNAseq/FASTQC/