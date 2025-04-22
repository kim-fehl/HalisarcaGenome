#!/bin/bash

cd /gpfs/data/gpfs0/vasiliy.zubarev/Sponge/Data/RNA-seq
export PATH=${PATH}:~/software/sratoolkit.3.1.1-centos_linux64/bin/
for line in `cat /gpfs/data/gpfs0/vasiliy.zubarev/Sponge/Data/RNA-seq/RNAseq_sample_list.txt | grep -v '#' | sed 's/\t/_/g'`; do
	ID=`echo ${line}|cut -f1 -d '_'`
	description=`echo ${line}|cut -f2,3,4,5,6 -d '_'`
	prefetch-orig.3.1.1 ${ID}
	fastq-dump-orig.3.1.1 ${ID}
	gzip ${ID}.fastq
	mv ./${ID}.fastq.gz ./${description}.fastq.gz
done