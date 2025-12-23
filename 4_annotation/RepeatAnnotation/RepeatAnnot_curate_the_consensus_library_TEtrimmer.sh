#!/bin/bash
#SBATCH --ntasks=1
#SBATCH --job-name=tetrimmer
#SBATCH --output=logs/log.%x.job_%j
#SBATCH --cpus-per-task=50
#SBATCH --time=18:00:00
#SBATCH --mem=150G

apptainer exec --writable-tmpfs \
	--bind /trinity/home/leonid.sidorov/halisarca_genome_project/TEtrimmer:/TEtrimmer \
	--bind /trinity/home/leonid.sidorov/halisarca_genome_project/data:/data \
	--bind /trinity/home/leonid.sidorov/halisarca_genome_project/pfam:/pfam \
	--bind /trinity/home/leonid.sidorov/halisarca_genome_project/te_trimming_results/:/output \
	$HOME/lab/gpfs/sif_containers/tetrimmer_1.4.0--hdfd78af_0.sif \
	python TEtrimmer/tetrimmer/TEtrimmer.py \
	-i /data/porifera_7species_repdb/porifera_7species_repdb-families.fa \
	-g /data/SKOL_HDuj_2_larger3k.fasta  \
	-o /output/ \
	--num_threads 50 \
	--classify_all
