#!/bin/bash
#SBATCH --partition=bigmem
#SBATCH --job-name=ONPsort
#SBATCH --mem=300G
#SBATCH --cpus-per-task 16
#SBATCH --time=2-00:00:00 
#SBATCH --output=/gpfs/khrameeva/Halisarca_analysis/2025_09_11_Nanopore_sorting/sort.log
#SBATCH --error=/gpfs/khrameeva/Halisarca_analysis/2025_09_11_Nanopore_sorting/sort.err

#Wrapper of scripts Nanopore_simple_sort.sh and Nanopore_longest_with_given_coverage.sh to use with SLURM.

#Activate seqkit dependency
source ~/software/miniconda3/bin/activate ~/software/bio_basics/

#Merge available Nanopore reads in one file
zcat /gpfs/khrameeva/Data/Halisarca_nanopore/SRR31896581.fastq.gz \
	/gpfs/khrameeva/Data/Halisarca_nanopore/SRR27326128.fastq.gz \
	/gpfs/khrameeva/Data/Halisarca_nanopore/SRR27326129.fastq.gz \
	/gpfs/khrameeva/Data/Halisarca_nanopore/SRR27326130.fastq.gz > /gpfs/khrameeva/Data/Halisarca_nanopore/Merged.fastq

seqkit stats -j 16 -a /gpfs/khrameeva/Data/Halisarca_nanopore/Merged.fastq >> seqkit_stats.txt

#Sort fastq file by length
bash /gpfs/khrameeva/Halisarca_analysis/2025_09_11_Nanopore_sorting/Nanopore_simple_sort_chatgpt.sh \
	/gpfs/khrameeva/Data/Halisarca_nanopore/Merged.fastq \
	/gpfs/khrameeva/Halisarca_analysis/2025_09_11_Nanopore_sorting/Halisarca_Nanopore_merged_len_sorted.fastq

seqkit stats -j 16 -a /gpfs/khrameeva/Halisarca_analysis/2025_09_11_Nanopore_sorting/Halisarca_Nanopore_merged_len_sorted.fastq >> seqkit_stats.txt

#Subset longest reads
#length is 198M*60x=11.88G
bash /gpfs/khrameeva/Halisarca_analysis/2025_09_11_Nanopore_sorting/Nanopore_longest_with_given_coverage.sh \
	/gpfs/khrameeva/Halisarca_analysis/2025_09_11_Nanopore_sorting/Halisarca_Nanopore_merged_len_sorted.fastq \
	/gpfs/khrameeva/Halisarca_analysis/2025_09_11_Nanopore_sorting/Halisarca_Nanopore_merged_subset60xlongest.fastq \
	11880000000

seqkit stats -j 16 -a /gpfs/khrameeva/Halisarca_analysis/2025_09_11_Nanopore_sorting/Halisarca_Nanopore_merged_subset60xlongest.fastq >> seqkit_stats.txt


