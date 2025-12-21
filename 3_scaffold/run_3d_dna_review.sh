#!/bin/bash
#SBATCH --partition=compute
#SBATCH --job-name=3D-DNA
#SBATCH --mem=150G
#SBATCH --cpus-per-task=24
#SBATCH --time=5-00:00:00
#SBATCH --output=/gpfs/khrameeva/Halisarca_analysis/2025_11_08_hic_scaffolding/manual_curation/batch1_rawchrom/curation3/3d-dna.log
#SBATCH --error=/gpfs/khrameeva/Halisarca_analysis/2025_11_08_hic_scaffolding/manual_curation/batch1_rawchrom/curation3/3d-dna.err
#SBATCH --mail-type=ALL
#SBATCH --mail-user=Vasiliy.Zubarev@skoltech.ru

source /home/khrameeva/software/miniconda3/bin/activate /home/khrameeva/software/juicer
export PATH=${PATH}:/home/khrameeva/software/3d-dna/

bash run-asm-pipeline-post-review.sh -q 30 --sort-output -r /gpfs/khrameeva/Halisarca_analysis/2025_11_08_hic_scaffolding/manual_curation/batch1_rawchrom/curation3/Assembly.review3.assembly \
	/gpfs/khrameeva/Halisarca_analysis/2025_10_08_Nanopore_longest_assembly/1_RESULTS/Nextdenovo_60x_pilon_purgedups_nomito_nobact.fasta \
	/gpfs/khrameeva/Halisarca_analysis/2025_11_08_hic_scaffolding/juicer_batch1_1/aligned/merged_nodups.txt


