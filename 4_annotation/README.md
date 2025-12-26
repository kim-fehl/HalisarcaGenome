# Annotation stage (4_annotation)

This folder contains scripts to build and refine genome annotations for *Halisarca dujardinii*.

## Overview
- Repeat annotation: `RepeatAnnotation/` (RepeatModeler/Masker, Tetrim, TEclass helpers).
- Gene prediction: `braker.sh` for BRAKER3 runs; `PASA_annotation_update.sh` for PASA refinement and UTR extension; `peaks2utr` invoked inside PASA pipeline.
- RNA-seq mapping & transcript assembly: `StringTie.sh` plus `StringTie_sources.tsv` describing RNA-seq inputs. **StringTie source FASTQs are downloaded automatically** (see script comments). Only representative (largest) replicates are included in StringTie runs by toggling the `Use` column in the TSV. De novo transcriptome merging/prep from IDB/ANU sources is **not covered by these scripts** and must be provided separately.
- ncRNA prediction: `RFAM.sh` (infernal), `barrnap.sh`, `tRNAscan-SE.sh`.
- Functional annotation: `Trinotate.sh` for PFAM/SwissProt/TrEMBL/KEGG/EggNOG annotations.
- Additional: `TMbed.sh` for transmembrane domain prediction; `RNAseq_mapping/` for mapping helpers.

## Usage notes
- Adjust paths, module/container environment, and thread counts as appropriate for your system.
- Most scripts assume input assemblies and reference indexes have been generated in earlier stages.
- Review download URLs in `StringTie_sources.tsv` and the comments in `StringTie.sh` before launching long runs.
