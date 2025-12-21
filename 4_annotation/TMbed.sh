#!/bin/bash
#SBATCH --partition=gpu
#SBATCH --job-name=TMbed
#SBATCH --mem=40G
#SBATCH --cpus-per-task=1
#SBATCH --gres=gpu:1
#SBATCH --time=3-00:00:00 
#SBATCH --output=/gpfs/data/gpfs0/vasiliy.zubarev/Sponge/Analysis/2025_12_18_Trinotate_SkHd3/TMbed.log
#SBATCH --error=/gpfs/data/gpfs0/vasiliy.zubarev/Sponge/Analysis/2025_12_18_Trinotate_SkHd3/TMbed.err

THREADS=40
WD=/gpfs/data/gpfs0/vasiliy.zubarev/Sponge/Analysis/2025_12_18_Trinotate_SkHd3/TMBed/

source activate ~/software/TMbed

cd $WD
python -m tmbed predict -f /gpfs/data/gpfs0/vasiliy.zubarev/Sponge/Analysis/2025_12_18_Trinotate_SkHd3/SkHd3_fannot_toTrinotate.proteins.fa \
	-p TMbed_predicted.txt \
	--out-format 4 \