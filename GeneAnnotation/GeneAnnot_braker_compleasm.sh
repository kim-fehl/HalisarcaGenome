#!/bin/bash
#SBATCH --partition=mem
#SBATCH --job-name=BRAKER3
#SBATCH --mem=150G
#SBATCH --cpus-per-task=48
#SBATCH --time=5-00:00:00 
#SBATCH --output=/gpfs/data/gpfs0/vasiliy.zubarev/Sponge/Analysis/2025_01_08_BRAKER_compleasm/braker.log
#SBATCH --error=/gpfs/data/gpfs0/vasiliy.zubarev/Sponge/Analysis/2025_01_08_BRAKER_compleasm/braker.err
#SBATCH --mail-type=ALL
#SBATCH --mail-user=Vasiliy.Zubarev@skoltech.ru


INPUT_BAM=/gpfs/data/gpfs0/vasiliy.zubarev/Sponge/Analysis/2024_12_02_RNAseq_filtering/bams/
INPUT_PROT=/gpfs/data/gpfs0/vasiliy.zubarev/Sponge/Data/OrthoDB/
ANALYSIS=/gpfs/data/gpfs0/vasiliy.zubarev/Sponge/Analysis/2025_01_08_BRAKER_compleasm/
CONFIG=/gpfs/data/gpfs0/vasiliy.zubarev/Sponge/Analysis/BRAKER_config/
THREADS=48

apptainer exec -B ${ANALYSIS}:/dir -B ${INPUT_BAM}:/bams -B ${CONFIG}:/config -B ${INPUT_PROT}:/prots --fakeroot ~/software/braker3_new.sif \
	braker.pl --genome=/dir/SKOL_HDuj_2_larger3k.fasta.masked \
	--bam=/bams/AUSTR_adult_16_norep_PE200_filtered_sorted.bam,\
/bams/AUSTR_larva_16_norep_PE200_filtered_sorted.bam,\
/bams/IDB_aggregates24h_Aug19_rep2_SE50_filtered_sorted.bam,\
/bams/IDB_aggregates24h_Aug19_rep3_SE50_filtered_sorted.bam,\
/bams/IDB_aggregates24h_Jan20_rep1_SE50_filtered_sorted.bam,\
/bams/IDB_aggregates24h_Jan20_rep2_SE50_filtered_sorted.bam,\
/bams/IDB_aggregates24h_Jan20_rep3_SE50_filtered_sorted.bam,\
/bams/IDB_aggregates24h_Mar21_norep_SE50_filtered_sorted.bam,\
/bams/IDB_aggregates24h_rep1_SE50_filtered_sorted.bam,\
/bams/IDB_aggregates24_Nov17_norep_PE250_filtered_sorted.bam,\
/bams/IDB_aggregates24_Nov18_rep1_SE50_filtered_sorted.bam,\
/bams/IDB_aggregates24_Nov18_rep2_SE50_filtered_sorted.bam,\
/bams/IDB_cells_Aug19_rep1_SE50_filtered_sorted.bam,\
/bams/IDB_cells_Aug19_rep2_SE50_filtered_sorted.bam,\
/bams/IDB_cells_Aug19_rep3_SE50_filtered_sorted.bam,\
/bams/IDB_cells_Jan20_rep2_SE50_filtered_sorted.bam,\
/bams/IDB_cells_Jan20_rep3_SE50_filtered_sorted.bam,\
/bams/IDB_cells_Jul17_norep_PE250_filtered_sorted.bam,\
/bams/IDB_cells_Mar21_norep_SE50_filtered_sorted.bam,\
/bams/IDB_cells_Nov17_norep_PE250_filtered_sorted.bam,\
/bams/IDB_cells_Nov18_rep1_SE50_filtered_sorted.bam,\
/bams/IDB_cells_Nov18_rep2_SE50_filtered_sorted.bam,\
/bams/IDB_cells_Nov18_rep3_SE50_filtered_sorted.bam,\
/bams/IDB_frozentissue_Jul17_norep_PE250_filtered_sorted.bam,\
/bams/IDB_tissue_Aug19_rep1_SE50_filtered_sorted.bam,\
/bams/IDB_tissue_Aug19_rep2_SE50_filtered_sorted.bam,\
/bams/IDB_tissue_Jan20_rep1_SE50_filtered_sorted.bam,\
/bams/IDB_tissue_Jan20_rep2_SE50_filtered_sorted.bam,\
/bams/IDB_tissue_Jan20_rep3_SE50_filtered_sorted.bam,\
/bams/IDB_tissue_Jul17_norep_PE250_filtered_sorted.bam,\
/bams/IDB_tissue_Mar21_norep_SE50_filtered_sorted.bam,\
/bams/IDB_tissue_Nov17_norep_PE250_filtered_sorted.bam,\
/bams/IDB_tissue_Nov18_rep1_SE50_filtered_sorted.bam,\
/bams/IDB_tissue_Nov18_rep2_SE50_filtered_sorted.bam \
	--species=Halisarca_dujardinii \
	--AUGUSTUS_CONFIG_PATH=/config \
	--prot_seq=/prots/Metazoa_odb11_plus6sponges_headerssimplified.fasta \
	--busco_lineage metazoa_odb10 \
	--threads=${THREADS}
	