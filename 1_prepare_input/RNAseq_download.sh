#!/bin/bash
#SBATCH --partition=compute
#SBATCH --job-name=SRA_download
#SBATCH --mem=30G
#SBATCH --cpus-per-task=12
#SBATCH --time=5-00:00:00
#SBATCH --output=/gpfs/khrameeva/Data/Halisarca_RNA/download.log
#SBATCH --error=/gpfs/khrameeva/Data/Halisarca_RNA/download.err
#SBATCH --mail-type=ALL
#SBATCH --mail-user=Vasiliy.Zubarev@skoltech.ru

cd /gpfs/khrameeva/Data/Halisarca_RNA/raw_for_annotation/
export PATH=${PATH}:~/software/sratoolkit.3.2.1-ubuntu64/bin
source ~/software/miniconda3/bin/activate ~/software/bio_basics

#FILTER_SE=IDB
#FILTER_PE=SPB

#Download, unpack and rename single-end libraries

for line in `cat /gpfs/khrameeva/Data/Halisarca_RNA/RNAseq_sample_list.txt | grep -v '#' | grep SE | sed 's/\t/_/g' | grep ${FILTER_SE}`; do
	ID=`echo ${line}|cut -f1 -d '_'`
	description=`echo ${line}|cut -f2,3,4,5,6 -d '_'`
	prefetch-orig.3.2.1 ${ID}
	fasterq-dump-orig.3.2.1 ${ID}
done
ls . | grep fastq | grep -v gz | parallel -j 12 gzip {}
for line in `cat /gpfs/khrameeva/Data/Halisarca_RNA/RNAseq_sample_list.txt | grep -v '#' | grep SE | sed 's/\t/_/g' | grep ${FILTER_SE}`; do
	ID=`echo ${line}|cut -f1 -d '_'`
	description=`echo ${line}|cut -f2,3,4,5,6 -d '_'`
	mv ./${ID}.fastq.gz ./${description}.fastq.gz
done

#Download unpack and rename paired-end libraries

for line in `cat /gpfs/khrameeva/Data/Halisarca_RNA/RNAseq_sample_list.txt | grep -v '#' | grep PE | sed 's/\t/_/g' | grep ${FILTER_PE}`; do
	ID=`echo ${line}|cut -f1 -d '_'`
	description=`echo ${line}|cut -f2,3,4,5,6 -d '_'`
	#prefetch-orig.3.2.1 ${ID}
	fasterq-dump-orig.3.2.1 ${ID}
done
ls . | grep fastq | grep -v gz | parallel -j 12 gzip {}
for line in `cat /gpfs/khrameeva/Data/Halisarca_RNA/RNAseq_sample_list.txt | grep -v '#' | grep PE | sed 's/\t/_/g' | grep ${FILTER_PE}`; do
	ID=`echo ${line}|cut -f1 -d '_'`
	description=`echo ${line}|cut -f2,3,4,5,6 -d '_'`
	mv ./${ID}_1.fastq.gz ./${description}_R1.fastq.gz
	mv ./${ID}_2.fastq.gz ./${description}_R2.fastq.gz
done