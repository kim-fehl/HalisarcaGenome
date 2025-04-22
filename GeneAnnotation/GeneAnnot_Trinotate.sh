#!/bin/bash
#SBATCH --partition=htc
#SBATCH --job-name=Trinotate
#SBATCH --mem=60G
#SBATCH --cpus-per-task=64
#SBATCH --time=23:59:00 
#SBATCH --output=/gpfs/data/gpfs0/vasiliy.zubarev/Sponge/Analysis/2025_04_16_Trinotate/Trinotate_tmhmm.log
#SBATCH --error=/gpfs/data/gpfs0/vasiliy.zubarev/Sponge/Analysis/2025_04_16_Trinotate/Trinotate_tmhmm.err

THREADS=64
WD=/gpfs/data/gpfs0/vasiliy.zubarev/Sponge/Analysis/2025_04_16_Trinotate
source activate ~/software/Trinotate_signalP
export TRINOTATE_DATA_DIR=/gpfs/data/gpfs0/vasiliy.zubarev/Sponge/Analysis/2025_04_16_Trinotate/Trinotate_data


#/beegfs/home/vasiliy.zubarev/software/Trinotate/bin/Trinotate  --create \
#--db SKOL_HDuj_2_fannot.sqlite \
#--trinotate_data_dir /gpfs/data/gpfs0/vasiliy.zubarev/Sponge/Analysis/2025_04_16_Trinotate/Trinotate_data/ \
#--use_diamond

#~/software/Trinotate/bin/util/Trinotate_GTF_or_GFF3_annot_prep.pl \
#--annot /gpfs/data/gpfs0/vasiliy.zubarev/Sponge/Results/Genome/Braker_compleasm_PASA_AGAT.gtf \
#--genome_fa /gpfs/data/gpfs0/vasiliy.zubarev/Sponge/Results/Genome/SKOL_HDuj_2_larger3k.fasta  \
#--out_prefix SKOL_HDuj_2_toTrinotate

#Trinotate --db ./SKOL_HDuj_2_fannot.sqlite \
#--init --gene_trans_map ./SKOL_HDuj_2_toTrinotate.gene-to-trans-map \
#--transcript_fasta ./SKOL_HDuj_2_toTrinotate.transcripts.cdna.fa \
#--transdecoder_pep ./SKOL_HDuj_2_toTrinotate.proteins.fa

cd ${WD}
Trinotate --db ./SKOL_HDuj_2_fannot.sqlite --CPU ${THREADS} \
               --transcript_fasta ./SKOL_HDuj_2_toTrinotate.transcripts.cdna.fa \
               --transdecoder_pep ./SKOL_HDuj_2_toTrinotate.proteins.fa \
               --trinotate_data_dir /gpfs/data/gpfs0/vasiliy.zubarev/Sponge/Analysis/2025_04_16_Trinotate/Trinotate_data \
               --run "tmhmmv2" \
               --use_diamond
