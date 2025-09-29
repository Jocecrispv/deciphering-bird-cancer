#! /bin/bash

# Deciphering Bird Cancer Pipeline

# This pipeline downloads coding sequences of Psittaciformes orthologs 
# (example: proto-oncogene SRC), aligns them, builds phylogenetic trees,
# and performs selection analysis with HyPhy.
# Developed in Linux terminal.


# 1. DOWNLOADING SEQUENCES FROM NCBI 

# Move into the working directory
cd your_directory_name

# Load conda
source /home/manager/anaconda3/etc/profile.d/conda.sh

# Activate the ncbi_datasets environment
conda activate ncbi_datasets

# Download coding sequences (CDS) of SRC orthologs in Psittaciformes
datasets download gene symbol src --include cds --ortholog Psittaciformes --filename practiceSRC.zip

# Unzip downloaded file
unzip practiceSRC.zip -d SRC-cds-practice

# Visualize directory tree
tree SRC-cds-practice

# Deactivate conda environment
conda deactivate

# Remove unnecessary files (keep only .fna sequences)
find /home/manager/Data/SRC-cds-practice/ncbi_dataset/data -type f ! -name "*.fna" -delete


# 2. SEQUENCE ALIGNMENT WITH MUSCLE

muscle -in SRC-cds-practice/ncbi_dataset/data/cds.fna \
       -out /home/manager/Data/SRC-cds-practice/ncbi_dataset/data/SRCmuscleAlignPrac.afa


# 3. PHYLOGENETIC TREE WITH RAxML

# Edit sequence headers: remove everything after ":" in FASTA IDs
cd /home/manager/Data/SRC-cds-practice/ncbi_dataset/data
awk '/^>/{ sub(/:.*/, "", $0) } 1' SRCmuscleAlignPrac.afa > SRCmuscleAlignMod1.afa

# Remove stop codons using HyPhy clean (cln)
hyphy cln Universal SRCmuscleAlignMod1.afa No/Yes SRCmuscleAlignMod2.afa

# (Optional) Preview first 40 lines of cleaned alignment
head -n 40 SRCmuscleAlignMod2.afa

# Activate phylogenetics environment for RAxML
source /home/manager/anaconda3/etc/profile.d/conda.sh
conda activate phylogenetics

# Build phylogenetic tree
raxmlHPC -s SRCmuscleAlignMod2.afa \
         -n SRCraxml_trees \
         -m GTRCAT \
         -f a \
         -x 123 \
         -p 256 \
         -N autoMRE

# Deactivate environment
conda deactivate

# Keep only best tree, remove bootstrap and bipartition files
find . -type f \( -name "RAxML_bootstrap*" -o -name "RAxML_bipartitions*" \) -delete

# Visualize tree with iTOL: https://itol.embl.de/


# 4. SELECTION ANALYSIS WITH HyPhy

# Notes:
# - LIBPATH specifies HyPhy library directory
# - Alignment file: codon alignment (from MUSCLE)
# - Tree file: best phylogenetic tree (from RAxML)
# - Output: results saved in JSON format

# aBSREL Analysis: Detect branches under positive selection
# Example command:
hyphy LIBPATH=/home/manager/anaconda3/lib/hyphy absrel \
      --alignment SRCmuscleAlignMod2.afa \
      --tree RAxML_bestTree.SRCraxml_trees \
      --branches All \
      --output /home/manager/Results/AllBranchesPsittaciformes/hyphySRC.json

# MEME Analysis: Detect sites under positive selection
# Example command:
# hyphy LIBPATH=/home/manager/anaconda3/lib/hyphy meme \
#       --alignment SRCmuscleAlignMod2.afa \
#       --tree RAxML_bestTree.SRCraxml_trees \
#       --output /home/manager/Results/MEME_Sites/hyphySRC_meme.json

# View results in HyPhy Vision (http://vision.hyphy.org)
