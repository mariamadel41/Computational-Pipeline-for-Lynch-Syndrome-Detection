# Computational-Pipeline-for-Lynch-Syndrome-Detection
Computational Pipeline for Lynch Syndrome Detection: Integrating Alignment, Variant Calling, and Annotation

## Overview
This bash script is designed to perform a series of steps for analyzing genomic data in the context of Lynch syndrome. The script takes FASTQ files as input, performs quality control, alignment, variant calling, annotation, and extraction of Lynch syndrome positions. It utilizes various bioinformatics tools and requires specific directory paths and files to be set up correctly.

## Prerequisites
Before running this script, make sure the following prerequisites are met:
- The necessary software tools and dependencies are installed, including FastQC, Trimmomatic, BWA, Samtools, and ANNOVAR. The required tools can be downloaded from the following location:
  [Tools Download](https://drive.google.com/drive/folders/18q7gafdHOHe7Hoo-ZVWeXwOExroNmBbN?usp=drive_link)
- Reference genome files are required for alignment and annotation. The reference genome file can be downloaded from the following location:
  [Reference Genome Download](https://drive.google.com/file/d/1-85dOBkNpqRyP99yt8P-IO4p7wFnRPJ_/view?usp=sharing)
- Annotation databases are required for variant annotation. The necessary annotation databases can be obtained from ANNOVAR.
- Input FASTQ files are present in the specified input directory.

## Usage
To use this script, follow these steps:

1. Modify the script variables:
   - `input_dir`: Set the path to the directory containing the input FASTQ files.
   - `output_dir`: Set the path to the directory where the output files will be generated.
   - `annovar_dir`: Set the path to the ANNOVAR tool directory.
   - `reference_genome_dir`: Set the path to the reference genome directory.
   - `trimmomatic_jar`: Set the path to the Trimmomatic JAR file.
   - `adapter_file`: Set the path to the Trimmomatic adapter file.

2. Run the script:
    ,,,
    bash run_analysis.sh <input_file_type>
    ,,,
    
 Replace `<input_file_type>` with either `single` or `paired` to specify the type of input FASTQ files.

3. The script will iterate over the FASTQ files in the input directory, performing the following steps for each sample:
- Quality control using FastQC.
- Trimming using Trimmomatic.
- Alignment using BWA.
- Conversion to BAM format using Samtools.
- Sorting and indexing the BAM file.
- Variant calling using bcftools.
- Annotation using ANNOVAR.
- Extraction of Lynch syndrome positions.

4. The output files will be generated in the specified output directory.

## Additional Resources
- The studies file containing the genomic data used in this analysis can be found at the following location:
[Studies File](https://www.ncbi.nlm.nih.gov/bioproject/PRJNA868287)

## Notes
- The script uses the `-e` option to exit immediately if any command fails (`set -e`).
- The script assumes that the required software tools and dependencies are installed and accessible in the specified directories. Make sure to adjust the paths if necessary.
- Ensure that the input FASTQ files follow the correct naming convention based on the `<input_file_type>` specified.
- The Trimmomatic command will be automatically adjusted based on the input file type (`single` or `paired`).
- The input file type should be specified when running the script by replacing `<input_file_type>` in the run command.

## Disclaimer
Please note that this script is provided as-is and may require further customization to suit your specific analysis needs. It is recommended to review and understand each step before running the script. Additionally, it is always a good practice to back up your data and seek help from the relevant software/tool developers or bioinformatics experts if needed.
Please make sure to replace the <input_file_type> placeholders with the appropriate input file type (single or paired).   
    
  
  
  
