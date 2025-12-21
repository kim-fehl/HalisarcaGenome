#!/bin/bash
#SBATCH --partition=compute
#SBATCH --job-name=BRAKER3
#SBATCH --mem=150G
#SBATCH --cpus-per-task=24
#SBATCH --time=10-00:00:00 
#SBATCH --output=/gpfs/khrameeva/Halisarca_analysis/2025_11_14_annotation/annot_BRAKER/BRAKER_v6_nextpolish/braker.log
#SBATCH --error=/gpfs/khrameeva/Halisarca_analysis/2025_11_14_annotation/annot_BRAKER/BRAKER_v6_nextpolish/braker.err
#SBATCH --mail-type=ALL
#SBATCH --mail-user=Vasiliy.Zubarev@skoltech.ru

INPUT_BAM=/gpfs/khrameeva/Halisarca_analysis/2025_11_14_annotation/RNAseq_mapping/map_SkHd3_nextpolish/map_iter2/
INPUT_PROT=/gpfs/khrameeva/Halisarca_analysis/2025_11_14_annotation/annot_BRAKER/OrthoDB/
INPUT_GENOME=/gpfs/khrameeva/Halisarca_analysis/2025_11_14_annotation/annot_BRAKER/Genome_softmasked/
ANALYSIS=/gpfs/khrameeva/Halisarca_analysis/2025_11_14_annotation/annot_BRAKER/BRAKER_v6_nextpolish/
CONFIG=/gpfs/khrameeva/Halisarca_analysis/2025_11_14_annotation/annot_BRAKER/BRAKER_config/

THREADS=24

singularity exec -B ${ANALYSIS}:/dir -B ${INPUT_BAM}:/bams -B ${CONFIG}:/config -B ${INPUT_PROT}:/prots -B ${INPUT_GENOME}:/genome ~/software/BRAKER3.sif \
	braker.pl --genome=/genome/genome_nextpolish_scaffolds.soft_masked.fasta \
	--bam=/bams/IDB_aggr/IDB_aggregates24h_Aug19_rep2_SE50.fastq.gz/Aligned_sorted_mapq30.bam,\
/bams/IDB_aggr/IDB_aggregates24h_Aug19_rep3_SE50.fastq.gz/Aligned_sorted_mapq30.bam,\
/bams/IDB_aggr/IDB_aggregates24h_Jan20_rep1_SE50.fastq.gz/Aligned_sorted_mapq30.bam,\
/bams/IDB_aggr/IDB_aggregates24h_Jan20_rep2_SE50.fastq.gz/Aligned_sorted_mapq30.bam,\
/bams/IDB_aggr/IDB_aggregates24h_rep1_SE50.fastq.gz/Aligned_sorted_mapq30.bam,\
/bams/IDB_aggr/IDB_aggregates24_Nov18_rep1_SE50.fastq.gz/Aligned_sorted_mapq30.bam,\
/bams/IDB_aggr/IDB_aggregates24_Nov18_rep2_SE50.fastq.gz/Aligned_sorted_mapq30.bam,\
/bams/IDB_aggr/IDB_cells_Aug19_rep1_SE50.fastq.gz/Aligned_sorted_mapq30.bam,\
/bams/IDB_aggr/IDB_cells_Aug19_rep2_SE50.fastq.gz/Aligned_sorted_mapq30.bam,\
/bams/IDB_aggr/IDB_cells_Aug19_rep3_SE50.fastq.gz/Aligned_sorted_mapq30.bam,\
/bams/IDB_aggr/IDB_cells_Jan20_rep1_SE50.fastq.gz/Aligned_sorted_mapq30.bam,\
/bams/IDB_aggr/IDB_cells_Jan20_rep2_SE50.fastq.gz/Aligned_sorted_mapq30.bam,\
/bams/IDB_aggr/IDB_cells_Nov18_rep1_SE50.fastq.gz/Aligned_sorted_mapq30.bam,\
/bams/IDB_aggr/IDB_cells_Nov18_rep2_SE50.fastq.gz/Aligned_sorted_mapq30.bam,\
/bams/IDB_aggr/IDB_cells_Nov18_rep3_SE50.fastq.gz/Aligned_sorted_mapq30.bam,\
/bams/IDB_aggr/IDB_tissue_Aug19_rep1_SE50.fastq.gz/Aligned_sorted_mapq30.bam,\
/bams/IDB_aggr/IDB_tissue_Aug19_rep2_SE50.fastq.gz/Aligned_sorted_mapq30.bam,\
/bams/IDB_aggr/IDB_tissue_Jan20_rep1_SE50.fastq.gz/Aligned_sorted_mapq30.bam,\
/bams/IDB_aggr/IDB_tissue_Jan20_rep2_SE50.fastq.gz/Aligned_sorted_mapq30.bam,\
/bams/IDB_aggr/IDB_tissue_Jan20_rep3_SE50.fastq.gz/Aligned_sorted_mapq30.bam,\
/bams/IDB_aggr/IDB_tissue_Nov18_rep1_SE50.fastq.gz/Aligned_sorted_mapq30.bam,\
/bams/IDB_aggr/IDB_tissue_Nov18_rep2_SE50.fastq.gz/Aligned_sorted_mapq30.bam,\
/bams/IDB_basic/IDB_aggregates24_Nov17_norep_PE250/Aligned_sorted_mapq30.bam,\
/bams/IDB_basic/IDB_cells_Jul17_norep_PE250/Aligned_sorted_mapq30.bam,\
/bams/IDB_basic/IDB_cells_Nov17_norep_PE250/Aligned_sorted_mapq30.bam,\
/bams/IDB_basic/IDB_frozentissue_Jul17_norep_PE250/Aligned_sorted_mapq30.bam,\
/bams/IDB_basic/IDB_tissue_Jul17_norep_PE250/Aligned_sorted_mapq30.bam,\
/bams/IDB_basic/IDB_tissue_Nov17_norep_PE250/Aligned_sorted_mapq30.bam,\
/bams/IDB_larva/IDB_larva_attachedmattress_1/Aligned_sorted_mapq30.bam,\
/bams/IDB_larva/IDB_larva_attachedmattress_2/Aligned_sorted_mapq30.bam,\
/bams/IDB_larva/IDB_larva_attachedmattress_3/Aligned_sorted_mapq30.bam,\
/bams/IDB_larva/IDB_larva_freemattress_1/Aligned_sorted_mapq30.bam,\
/bams/IDB_larva/IDB_larva_freemattress_2/Aligned_sorted_mapq30.bam,\
/bams/IDB_larva/IDB_larva_freemattress_3/Aligned_sorted_mapq30.bam,\
/bams/IDB_larva/IDB_larva_freeswimming_2/Aligned_sorted_mapq30.bam,\
/bams/IDB_larva/IDB_larva_intissuelarva_1/Aligned_sorted_mapq30.bam,\
/bams/IDB_larva/IDB_larva_intissuelarva_2/Aligned_sorted_mapq30.bam,\
/bams/IDB_larva/IDB_larva_intissuelarva_3/Aligned_sorted_mapq30.bam,\
/bams/IDB_larva/IDB_larva_tissue_1/Aligned_sorted_mapq30.bam,\
/bams/IDB_larva/IDB_larva_tissue_2/Aligned_sorted_mapq30.bam,\
/bams/IDB_larva/IDB_larva_tissue_3/Aligned_sorted_mapq30.bam,\
/bams/IDB_heatshock/IDB_heatshock_60min-inc0h_1/Aligned_sorted_mapq30.bam,\
/bams/IDB_heatshock/IDB_heatshock_60min-inc0h_2/Aligned_sorted_mapq30.bam,\
/bams/IDB_heatshock/IDB_heatshock_60min-inc0h_3/Aligned_sorted_mapq30.bam,\
/bams/IDB_heatshock/IDB_heatshock_60min-inc20h_1/Aligned_sorted_mapq30.bam,\
/bams/IDB_heatshock/IDB_heatshock_60min-inc20h_2/Aligned_sorted_mapq30.bam,\
/bams/IDB_heatshock/IDB_heatshock_60min-inc20h_3/Aligned_sorted_mapq30.bam \
	--workingdir /dir \
	--species=Halisarca_dujardinii6 \
	--AUGUSTUS_CONFIG_PATH=/config \
	--prot_seq=/prots/Metazoa_plus6sponges_headersimplified.faa \
	--busco_lineage metazoa_odb10 \
	--gff3 \
	--threads=${THREADS}
	