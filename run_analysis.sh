#!/bin/bash

set -e  # Exit immediately if any command fails

input_dir="/media/mariam/Mariam/study-result/Grad_project"
output_dir="/home/mariam/result"
annovar_dir="/home/mariam/Lynch/tools/annovar"
reference_genome_dir="/home/mariam/Lynch/reference2"
trimmomatic_jar="/home/mariam/Lynch/tools/trimmomatic.jar"
adapter_file="/home/mariam/Lynch/tools/Trimmomatic-0.39/adapters/TruSeq3-PE.fa"

# Step 1: Find forward files and iterate over them
find "$input_dir" -name "*_1.fastq" | while read -r forward_file; do
  reverse_file="${forward_file/_1/_2}"
  filename=$(basename "$forward_file")
  sample="${filename%_1.fastq}"

  termo_out_forward_paired="$output_dir/output_forward_paired_${sample}.fq.gz"
  termo_out_forward_unpaired="$output_dir/output_forward_unpaired_${sample}.fq.gz"
  termo_out_reverse_paired="$output_dir/output_reverse_paired_${sample}.fq.gz"
  termo_out_reverse_unpaired="$output_dir/output_reverse_unpaired_${sample}.fq.gz"
  aligned_sam="$output_dir/aligned_${sample}.sam"
  aligned_bam="$output_dir/aligned_${sample}.bam"
  sorted_bam="$output_dir/sorted_reads_${sample}.bam"
  variants_vcf="$output_dir/variants_${sample}.vcf"
  output_avinput="$output_dir/output.avinput_${sample}"
  output_avinput_function="$output_dir/output.avinput_${sample}.variant_function"
  lynch_positions_file="$output_dir/Lynch_positions_in_file_${sample}.txt"

  # Step 2: Check quality with fastqc
  fastqc "$forward_file" "$reverse_file" -o "$output_dir" || { echo "FastQC failed for sample: $sample"; exit 1; }

  # Step 3: Use Trimmomatic
  java -jar "$trimmomatic_jar" PE -phred33 "$forward_file" "$reverse_file" \
    "$termo_out_forward_paired" "$termo_out_forward_unpaired" \
    "$termo_out_reverse_paired" "$termo_out_reverse_unpaired" \
    ILLUMINACLIP:"$adapter_file":2:30:10 LEADING:3 TRAILING:3 SLIDINGWINDOW:4:15 MINLEN:36 || { echo "Trimmomatic failed for sample: $sample"; exit 1; }
 # Step 5: Alignment
  bwa mem  "$reference_genome_dir/Homo_sapiens_assembly38.fasta" \
    "$termo_out_forward_paired" "$termo_out_reverse_paired" > "$aligned_sam"

  # Step 6: Conversion to BAM format
  samtools view -b "$aligned_sam" > "$aligned_bam"

  # Step 7: Sorting and indexing the BAM file
  samtools sort "$aligned_bam" -o "$sorted_bam"
  samtools index "$sorted_bam"

  # Step 8: Variant calling
  bcftools mpileup -f "$reference_genome_dir/Homo_sapiens_assembly38.fasta" "$sorted_bam" > "$variants_vcf.tmp"
  bcftools call -mv -Ov "$variants_vcf.tmp" > "$variants_vcf"
  rm "$variants_vcf.tmp"

  # Step 9: Annotation
  "$annovar_dir/convert2annovar.pl" -format vcf4 "$variants_vcf" > "$output_avinput"
  "$annovar_dir/annotate_variation.pl" -geneanno -dbtype refGene "$output_avinput" "$annovar_dir/humandb/" > "$output_avinput_function"

  # Step 10: Extract Lynch syndrome positions
  grep -E 'MLH1|MSH2|MSH6|PMS2|EPCAM' "$output_avinput_function" > "${lynch_positions_file}"

done






