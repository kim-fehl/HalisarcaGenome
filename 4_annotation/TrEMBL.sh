#!/bin/bash
#SBATCH --ntasks=1
#SBATCH --job-name=trembl_search
#SBATCH --output=logs/log.%x.job_%j
#SBATCH --cpus-per-task=32
#SBATCH --time=6-00:00:00
#SBATCH --partition=meme
#SBATCH --mem=100G

export MAIN_DIR=$HOME/halisarca_genome_project

cd $MAIN_DIR
# download database
mmseqs databases UniProtKB/TrEMBL $MAIN_DIR/gene_annotations/trembl tmp

# search against database
mmseqs easy-search \
    ./SkHd3_proteins.faa \
    $MAIN_DIR/gene_annotations/trembl \
    $MAIN_DIR/gene_annotations/trembl.res.m8 tmp \
    --split-memory-limit 100G --threads 32

# Filter the results
Rscript ./scripts/TrEMBL_filter.r