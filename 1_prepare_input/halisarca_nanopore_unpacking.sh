#!/bin/bash
#SBATCH --partition=compute
#SBATCH --job-name=SPAdes_readcorrect
#SBATCH --mem=100G
#SBATCH --cpus-per-task=4
#SBATCH --time=1-00:00:00
#SBATCH --output=/gpfs/khrameeva/Data/Halisarca_nanopore/unpack.log
#SBATCH --error=/gpfs/khrameeva/Data/Halisarca_nanopore/unpack.err
#SBATCH --mail-type=ALL
#SBATCH --mail-user=Vasiliy.Zubarev@skoltech.ru

/home/khrameeva/software/SRA_toolkit/sratoolkit.3.2.1-ubuntu64/bin/prefetch-orig.3.2.1 SRX23003149
/home/khrameeva/software/SRA_toolkit/sratoolkit.3.2.1-ubuntu64/bin/prefetch-orig.3.2.1 SRX23003150
/home/khrameeva/software/SRA_toolkit/sratoolkit.3.2.1-ubuntu64/bin/prefetch-orig.3.2.1 SRX23003151
/home/khrameeva/software/SRA_toolkit/sratoolkit.3.2.1-ubuntu64/bin/fastq-dump-orig.3.2.1 SRX23003149
gzip SRX23003149.fastq
/home/khrameeva/software/SRA_toolkit/sratoolkit.3.2.1-ubuntu64/bin/fastq-dump-orig.3.2.1 SRX23003150
gzip SRX23003150.fastq
/home/khrameeva/software/SRA_toolkit/sratoolkit.3.2.1-ubuntu64/bin/fastq-dump-orig.3.2.1 SRX23003151
gzip SRX23003151.fastq
