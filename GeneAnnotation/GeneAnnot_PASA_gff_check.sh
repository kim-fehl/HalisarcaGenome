#!/bin/bash
#SBATCH --partition=htc
#SBATCH --job-name=PASA_annot_update
#SBATCH --mem=5G
#SBATCH --cpus-per-task=20
#SBATCH --time=1:00:00 
#SBATCH --output=/gpfs/data/gpfs0/vasiliy.zubarev/Sponge/Analysis/2025_03_28_PASA_annot_update/gffcheck.log
#SBATCH --error=/gpfs/data/gpfs0/vasiliy.zubarev/Sponge/Analysis/2025_03_28_PASA_annot_update/gffcheck.err
#SBATCH --mail-type=ALL
#SBATCH --mail-user=Vasiliy.Zubarev@skoltech.ru

source activate /beegfs/home/vasiliy.zubarev/software/PASA/
export DBI_DRIVER=SQLite
PASAHOME=/beegfs/home/vasiliy.zubarev/software/PASA/opt/pasa-2.5.3

$PASAHOME/misc_utilities/pasa_gff3_validator.pl /gpfs/data/gpfs0/vasiliy.zubarev/Sponge/Results/Genome/braker_compleasm_AGAT_cleaned.gff3 > gffcheck.out
