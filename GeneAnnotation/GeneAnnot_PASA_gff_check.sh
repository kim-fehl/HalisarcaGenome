#!/usr/bin/env bash
set -euo pipefail

##### CONSTANTS #####
# Working directories
GENOME_DIR=/home/lab/kim/hd/genome

# Fix BRAKER's GFF to pass through PASA GFF validator:
# Change hierarchy from "exon/CDS -> transcript -> mRNA -> gene"
#                    to "exon/CDS -> mRNA -> gene"
awk -F'\t' 'BEGIN{OFS=FS}
  $3=="mRNA" && $2=="GeneMark.hmm3" { next }
  $3=="transcript" { $3="mRNA" }
  { print }
' ${GENOME_DIR}/braker_AGAT_mitoCleaned.gff3 \
> ${GENOME_DIR}/braker_AGAT_mitoCleaned_PASA.gff3

$PASAHOME/misc_utilities/pasa_gff3_validator.pl \
${GENOME_DIR}/braker_AGAT_mitoCleaned_PASA.gff3 \
> ${GENOME_DIR}/pasa_gff3_validator.log
