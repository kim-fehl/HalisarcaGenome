#!/bin/bash

export PATH=${PATH}:~/software
DIR=/gpfs/data/gpfs0/vasiliy.zubarev/Sponge/Data/Related_genomes

for line in `cat $DIR/genomes_list.txt | grep -v '#' | sed 's/\t/_/g'`; do
	cd $DIR
	ID=`echo $line | cut -f1,2 -d '_'`
	echo $ID
	species=`echo $line | cut -f3,4 -d '_'`
	echo $species
	assembly=`echo $line | cut -f5 -d '_'`
	echo $assembly
	datasets download genome accession $ID --include gff3,rna,cds,protein,genome,seq-report
	mkdir tmp
	unzip ./ncbi_dataset.zip -d ./tmp/
	rm ncbi_dataset.zip
	mkdir ${ID}_${species}
	echo "tmp/ncbi_dataset/data/${ID}/${ID}_${assembly}_genomic.fna"
	echo "result of ls command:"
	ls tmp/ncbi_dataset/data/${ID}/${ID}_${assembly}_genomic.fna
	echo "now copying"
	cp tmp/ncbi_dataset/data/${ID}/${ID}_${assembly}_genomic.fna ${ID}_${species}/${ID}_${species}_genome.fna
	cp tmp/ncbi_dataset/data/${ID}/rna.fna ${ID}_${species}/${ID}_${species}_rna.fna
	cp tmp/ncbi_dataset/data/${ID}/protein.faa ${ID}_${species}/${ID}_${species}_protein.faa
	cp tmp/ncbi_dataset/data/${ID}/genomic.gff ${ID}_${species}/${ID}_${species}_annotation.gff
	cp tmp/ncbi_dataset/data/${ID}/cds_from_genomic.fna ${ID}_${species}/${ID}_${species}_cds.fna
	rm -r ./tmp
done
	