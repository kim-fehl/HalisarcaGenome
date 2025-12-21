#!/bin/bash
#SBATCH --partition=bigmem
#SBATCH --job-name=pilon
#SBATCH --mem=500G
#SBATCH --cpus-per-task=24
#SBATCH --time=2-00:00:00
#SBATCH --output=/gpfs/khrameeva/Halisarca_analysis/2025_10_08_Nanopore_longest_assembly/Pilon/Pilon_nextdenovo.log
#SBATCH --error=/gpfs/khrameeva/Halisarca_analysis/2025_10_08_Nanopore_longest_assembly/Pilon/Pilon_nextdenovo.err
#SBATCH --mail-type=ALL
#SBATCH --mail-user=Vasiliy.Zubarev@skoltech.ru

#source /home/khrameeva/software/miniconda3/bin/activate /home/khrameeva/software/bio_basics

cd /gpfs/khrameeva/Halisarca_analysis/2025_10_08_Nanopore_longest_assembly/Pilon/Pilon_nextdenovo/
#bwa mem -T 30 -t 24 \
#	/gpfs/khrameeva/Halisarca_analysis/2025_10_08_Nanopore_longest_assembly/Nextdenovo/assembly_rundir/03.ctg_graph/nd.asm.fasta \
#	/gpfs/khrameeva/Data/Halisarca_illumina/Gubka_250_R1_trimmed.fastq.gz \
#	/gpfs/khrameeva/Data/Halisarca_illumina/Gubka_250_R2_trimmed.fastq.gz | samtools view -F 4 --threads 24 -o Pilon_nextdenovo_mapped.sam

#samtools view -Sb Pilon_nextdenovo_mapped.sam \
#	-t /gpfs/khrameeva/Halisarca_analysis/2025_10_08_Nanopore_longest_assembly/Nextdenovo/assembly_rundir/03.ctg_graph/nd.asm.fasta.fai | samtools sort > Pilon_nextdenovo_mapped_sorted.bam

#samtools index Pilon_nextdenovo_mapped_sorted.bam

source /home/khrameeva/software/miniconda3/bin/activate /home/khrameeva/software/pilon 
export _JAVA_OPTIONS="-Xms512m -Xmx450g"
pilon --genome /gpfs/khrameeva/Halisarca_analysis/2025_10_08_Nanopore_longest_assembly/Nextdenovo/assembly_rundir/03.ctg_graph/nd.asm.fasta \
	--frags ./Pilon_nextdenovo_mapped_sorted.bam \
	--outdir . --output HDuj_Nextdenovo_Pilon --fix "snps,indels" --diploid --changes --tracks --threads 24