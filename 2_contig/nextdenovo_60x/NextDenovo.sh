#!/bin/bash
#SBATCH --partition=bigmem
#SBATCH --job-name=NextDenovo
#SBATCH --mem=700G
#SBATCH --cpus-per-task=24
#SBATCH --time=5-00:00:00
#SBATCH --output=/gpfs/khrameeva/Halisarca_analysis/2025_10_08_Nanopore_longest_assembly/Nextdenovo/NextDenovo_allreads.log
#SBATCH --error=/gpfs/khrameeva/Halisarca_analysis/2025_10_08_Nanopore_longest_assembly/Nextdenovo/NextDenovo_allreads.err
#SBATCH --mail-type=ALL
#SBATCH --mail-user=Vasiliy.Zubarev@skoltech.ru

source /home/khrameeva/software/miniconda3/bin/activate /home/khrameeva/software/nextdenovo

nextDenovo run.cfg