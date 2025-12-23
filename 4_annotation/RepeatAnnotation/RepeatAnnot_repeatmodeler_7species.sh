#!/bin/bash
#SBATCH --partition=mem
#SBATCH --job-name=RepeatModeler
#SBATCH --mem=100G
#SBATCH --cpus-per-task=100
#SBATCH --time=5-00:00:00 
#SBATCH --output=/gpfs/data/gpfs0/vasiliy.zubarev/Sponge/Analysis/2024_12_05_RepeatModeler/RepeatModeler_recover.log
#SBATCH --error=/gpfs/data/gpfs0/vasiliy.zubarev/Sponge/Analysis/2024_12_05_RepeatModeler/RepeatModeler_recover.err
#SBATCH --mail-type=ALL
#SBATCH --mail-user=Vasiliy.Zubarev@skoltech.ru


source activate /beegfs/home/vasiliy.zubarev/software/RepeatMasker/

DIR=/gpfs/data/gpfs0/vasiliy.zubarev/Sponge/Analysis/2024_12_05_RepeatModeler/RepeatModeler/
cd ${DIR}

RepeatModeler -threads 100 \
	-LTRStruct \
	-database /gpfs/data/gpfs0/vasiliy.zubarev/Sponge/Analysis/2024_12_05_RepeatModeler/porifera_7species_repdb/porifera_7species_repdb

#singularity exec --fakeroot -B /gpfs/data/gpfs0/vasiliy.zubarev/Sponge/Analysis/2024_12_05_RepeatModeler/porifera_7species_repdb/:/db -B ${PWD}:${PWD} \
#	/beegfs/home/vasiliy.zubarev/software/RepeatModeler2.0.6.sif RepeatModeler \
#	-threads 100 \
#	-srand 2024 \
#	-LTRStruct \
#	-engine ncbi \
#	-database /db/porifera_7species_repdb 
