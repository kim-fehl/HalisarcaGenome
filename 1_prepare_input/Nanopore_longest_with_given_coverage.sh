#!/bin/bash

#Script to subset longest reads with given coverage from fastq file sorted by length, part 2.
#bash Nanopore_longest_with_given_coverage.sh [INPUT_SORTED_BY_LENGTH_FASTQ] [OUTPUT_FASTQ] [TOTAL_LENGTH]
#TOTAL_LENGTH = genome length * coverage

INPUT_FASTQ=$1
OUTPUT_FASTQ=$2
LENGTH=$3

awk -v max_bases=${LENGTH} -v out=${OUTPUT_FASTQ} '
NR%4==0 { 
    total_bases += length($0); 
    read_count++; 
}
{ 
    print > out; 
}
total_bases >= max_bases { 
    exit; 
}' ${INPUT_FASTQ}

#NR%4==2: Targets the sequence line (2nd line in each 4-line FASTQ block). 
#total_bases += length($0): Adds the length of the read to the cumulative base count. 
#print > "output.fastq": Writes all lines to the output file.
#total_bases >= max_bases: Stops when the target base count is reached.
#replace 1000000 by a desired constant (exp. genome size * coverage)
