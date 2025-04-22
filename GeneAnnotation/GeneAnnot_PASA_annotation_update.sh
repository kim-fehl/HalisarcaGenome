#!/bin/bash
#SBATCH --partition=htc
#SBATCH --job-name=PASA_annot_update
#SBATCH --mem=32G
#SBATCH --cpus-per-task=32
#SBATCH --time=1-00:00:00 
#SBATCH --output=/gpfs/data/gpfs0/vasiliy.zubarev/Sponge/Analysis/2025_03_28_PASA_annot_update/annot_compare.log
#SBATCH --error=/gpfs/data/gpfs0/vasiliy.zubarev/Sponge/Analysis/2025_03_28_PASA_annot_update/annot_compare.err
#SBATCH --mail-type=ALL
#SBATCH --mail-user=Vasiliy.Zubarev@skoltech.ru

source activate /beegfs/home/vasiliy.zubarev/software/PASA/
export DBI_DRIVER=SQLite
PASAHOME=/beegfs/home/vasiliy.zubarev/software/PASA/opt/pasa-2.5.3
WD=/gpfs/data/gpfs0/vasiliy.zubarev/Sponge/Analysis/2025_03_28_PASA_annot_update/

cd ${WD}

#${PASAHOME}/bin/seqclean ${WD}/HADA01_1.fasta
#
#${PASAHOME}/Launch_PASA_pipeline.pl \
#	-c ${WD}/pasa.alignAssembly.Template.txt \
#	-C -R -g ${WD}/SKOL_HDuj_2_larger3k.fasta \
#	-t ${WD}/HADA01_1.fasta.clean \
#	-T -u ${WD}/HADA01_1.fasta \
#	--ALIGNERS blat,gmap,minimap2 \
#	--CPU 32
#
#$PASAHOME/scripts/Load_Current_Gene_Annotations.dbi \
#		-c pasa.annotationCompare.Template.txt \
#		-g /gpfs/data/gpfs0/vasiliy.zubarev/Sponge/Results/Genome/SKOL_HDuj_2_larger3k.fasta \
#		-P /gpfs/data/gpfs0/vasiliy.zubarev/Sponge/Results/Genome/braker_compleasm_AGAT_cleaned.gff3
#
$PASAHOME/Launch_PASA_pipeline.pl \
		-c pasa.annotationCompare.Template.txt \
		-A \
		-g /gpfs/data/gpfs0/vasiliy.zubarev/Sponge/Results/Genome/SKOL_HDuj_2_larger3k.fasta \
		-t ${WD}/HADA01_1.fasta.clean \
		--CPU 32