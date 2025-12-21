#!/bin/bash
#SBATCH --partition=compute
#SBATCH --job-name=purge_dups
#SBATCH --mem=150G
#SBATCH --cpus-per-task=24
#SBATCH --time=2-00:00:00
#SBATCH --output=/gpfs/khrameeva/Halisarca_analysis/2025_10_08_Nanopore_longest_assembly/Purge_dups/nextdenovo_pilon/purge_dups.log
#SBATCH --error=/gpfs/khrameeva/Halisarca_analysis/2025_10_08_Nanopore_longest_assembly/Purge_dups/nextdenovo_pilon/purge_dups.err
#SBATCH --mail-type=ALL
#SBATCH --mail-user=Vasiliy.Zubarev@skoltech.ru

INPUT_GENOME=/gpfs/khrameeva/Halisarca_analysis/2025_10_08_Nanopore_longest_assembly/Pilon/Pilon_nextdenovo/HDuj_Nextdenovo_Pilon.fasta
INPUT_R1=/gpfs/khrameeva/Data/Halisarca_illumina/Gubka_250_R1_trimmed.fastq.gz
INPUT_R2=/gpfs/khrameeva/Data/Halisarca_illumina/Gubka_250_R2_trimmed.fastq.gz
WD=/gpfs/khrameeva/Halisarca_analysis/2025_10_08_Nanopore_longest_assembly/Purge_dups/nextdenovo_pilon/
OUT_MAPPED=Nextdenovo_pilon_polished_mapped_sorted.bam
OUT_PREFIX=HDuj_Nextdenovo_Pilon_purgedups

source ~/software/miniconda3/bin/activate ~/software/purge_dups
cd $WD

samtools faidx ${INPUT_GENOME}
#bwa index ${INPUT_GENOME}
bwa mem -T 30 -t 24 \
	${INPUT_GENOME} \
	${INPUT_R1} \
	${INPUT_R2} | samtools view -F 4 --threads 24 -o tmp_mapped.sam

samtools view -Sb tmp_mapped.sam \
	-t ${INPUT_GENOME}.fai | samtools sort > ${OUT_MAPPED}

samtools index ${OUT_MAPPED}

ngscstat -q 30 -M 300 -L 1000 ${OUT_MAPPED}

calcuts TX.stat > cutoffs 2>calcults.log

split_fa ${INPUT_GENOME} > pri_asm.split

minimap2 -xasm5 -DP pri_asm.split pri_asm.split | gzip -c - > pri_asm.split.self.paf.gz

purge_dups -2 -T cutoffs -c TX.base.cov pri_asm.split.self.paf.gz > dups.bed 2> purge_dups.log

get_seqs -e -p ${OUT_PREFIX} dups.bed ${INPUT_GENOME}

