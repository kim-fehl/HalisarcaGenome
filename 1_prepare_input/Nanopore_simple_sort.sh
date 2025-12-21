#!/bin/bash

#Script to subset longest reads with given coverage from fastq file sorted by length, part 1.
#bash Nanopore_simple_sort.sh [INPUT_NOT_SORTED_BY_LENGTH_FASTQ] [OUTPUT_SORTED_BY_LENGTH_FASTQ]


# Input and output files
INPUT_FASTQ=$1
OUTPUT_FASTQ=$2

# Check if input file exists
if [ ! -f "$INPUT_FASTQ" ]; then
    echo "Error: Input file '$INPUT_FASTQ' not found."
    exit 1
fi

# Process and sort
awk '{
    header=$0; getline seq; getline plus; getline qual;
    len=length(seq);
    printf "%09d\t%s\n", len, header "\t" seq "\t" plus "\t" qual;
}' "$INPUT_FASTQ" | sort -r -n -k 1 | cut -f2,3,4,5 | tr "\t" "\n" > "$OUTPUT_FASTQ"

echo "Reads sorted by length and saved to '$OUTPUT_FASTQ'"
