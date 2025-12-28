# HalisarcaGenome

Storage for code used to assemble and annotate the genome of the sponge *Halisarca dujardinii*.

## Input data 
- Whole-genome sequencing: Oxford Nanopore (4 libraries, 39.15 GB) and Illumina (2 libraries, 47.98 GB).
- Hi-C sequencing: 6 libraries, 52.90 GB.
- RNA sequencing: 4 datasets (intact tissue across seasons and reaggregation/developmental stages), 456.94 GB total.
- De novo Transcriptome assemblies
- Single-cell RNA sequencing: 2 libraries, 57.44 GB.

## Reproducing the pipeline
Scripts are organized per stage; adapt paths, container/module environments, and input accessions before execution. 

## Repository structure
- `1_prepare_input`: download and QC/trim ONT, Illumina, Hi-C, and RNA-seq libraries (fastp); select longest ONT reads for target coverage; basic QC summaries.
- `2_contig`: assemble with NextDenovo (60x longest ONT reads), polish with nextpolish and pilon, remove haplotigs with purge_dups, screen contamination with Kraken and NCBI BLAST.
- `3_scaffold`: Hi-C scaffolding via 3D-DNA pipeline and manual curation in Juicebox to produce the chromosome-level assembly.
- `4_annotation`: 
    - RepeatAnnotation (RepeatModeler/Masker, Tetrim, TEclass); 
    - gene prediction with BRAKER3; 
    - RNA-seq mapping and transcript reconstruction (STAR/StringTie); 
    - model refinement and UTR extension with PASA/peaks2utr; 
    - ncRNA prediction (infernal/RFAM, barrnap, tRNAscan-SE); 
    - TMbed for transmembrane domains; 
    - functional annotation with Trinotate.
- `5_validation`: STAR index generation and mapping; single-cell reference builds and counts with CellRanger; sequencing subsampling helpers.
- `6_finalizing_and_plots`: downstream summaries including BUSCO plotting (R Markdown).

