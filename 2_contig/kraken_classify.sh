#!/bin/bash
#SBATCH --partition=compute
#SBATCH --job-name=KRAKEN
#SBATCH --mem=150G
#SBATCH --cpus-per-task=24
#SBATCH --time=5-00:00:00
#SBATCH --output=/gpfs/khrameeva/Halisarca_analysis/2025_10_08_Nanopore_longest_assembly/KRAKEN/classify.log
#SBATCH --error=/gpfs/khrameeva/Halisarca_analysis/2025_10_08_Nanopore_longest_assembly/KRAKEN/classify.err
#SBATCH --mail-type=ALL
#SBATCH --mail-user=Vasiliy.Zubarev@skoltech.ru

DBNAME=~/software/kraken2_db/

source /home/khrameeva/software/miniconda3/bin/activate /home/khrameeva/software/kraken2
kraken2 --db $DBNAME /gpfs/khrameeva/Halisarca_analysis/2025_10_08_Nanopore_longest_assembly/Purge_dups/nextdenovo_pilon_middle/Nextdenovo_purgedups_strict.purged.fa > Nextdenovo_purgedups_strict_purged_KRAKEN.txt