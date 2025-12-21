#!/bin/bash
#SBATCH --partition=htc
#SBATCH --job-name=Trinotate
#SBATCH --mem=60G
#SBATCH --cpus-per-task=40
#SBATCH --time=23:59:00 
#SBATCH --output=/gpfs/data/gpfs0/vasiliy.zubarev/Sponge/Analysis/2025_12_18_Trinotate_SkHd3/Trinotate_basic.log
#SBATCH --error=/gpfs/data/gpfs0/vasiliy.zubarev/Sponge/Analysis/2025_12_18_Trinotate_SkHd3/Trinotate_basic.err

THREADS=40
WD=/gpfs/data/gpfs0/vasiliy.zubarev/Sponge/Analysis/2025_12_18_Trinotate_SkHd3
source activate ~/software/Trinotate
export TRINOTATE_DATA_DIR=/gpfs/data/gpfs0/vasiliy.zubarev/Sponge/Analysis/2025_04_16_Trinotate/Trinotate_data

cd $WD

/beegfs/home/vasiliy.zubarev/software/Trinotate/bin/Trinotate  --create \
--db SkHd3_fannot.sqlite \
--trinotate_data_dir /gpfs/data/gpfs0/vasiliy.zubarev/Sponge/Analysis/2025_04_16_Trinotate/Trinotate_data/ \
--use_diamond

~/software/Trinotate/bin/util/Trinotate_GTF_or_GFF3_annot_prep.pl \
--annot /gpfs/data/gpfs0/vasiliy.zubarev/Sponge/Analysis/2025_12_18_Trinotate_SkHd3/SkHd3_annot_nuclear_mito.gtf \
--genome_fa /gpfs/data/gpfs0/vasiliy.zubarev/Sponge/Analysis/2025_12_18_Trinotate_SkHd3/genome_nextpolish_scaffolds_mito.fasta  \
--out_prefix SkHd3_fannot_toTrinotate

Trinotate --db SkHd3_fannot.sqlite \
--init --gene_trans_map ./SkHd3_fannot_toTrinotate.gene-to-trans-map \
--transcript_fasta ./SkHd3_fannot_toTrinotate.transcripts.cdna.fa \
--transdecoder_pep ./SkHd3_fannot_toTrinotate.proteins.fa

cd ${WD}

Trinotate --db ./SkHd3_fannot.sqlite --CPU ${THREADS} \
               --transcript_fasta ./SkHd3_fannot_toTrinotate.transcripts.cdna.fa \
               --transdecoder_pep ./SkHd3_fannot_toTrinotate.proteins.fa \
               --trinotate_data_dir /gpfs/data/gpfs0/vasiliy.zubarev/Sponge/Analysis/2025_04_16_Trinotate/Trinotate_data \
               --run "swissprot_blastp swissprot_blastx pfam EggnogMapper infernal signalp6 tmhmmv2" \
               --use_diamond
