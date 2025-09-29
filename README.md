# Deciphering Bird Cancer

Pipeline for detecting positive selection in Psittaciformes genes (example: proto-oncogene *SRC*) potentially linked to cancer resistance.

## Overview

This repository contains a Linux-based bioinformatics pipeline that:

1. Downloads coding sequences of Psittaciformes orthologs from NCBI  
2. Performs sequence alignment with **MUSCLE**  
3. Builds phylogenetic trees with **RAxML**  
4. Runs selection analysis with **HyPhy** (MEME, aBSREL)  

The pipeline was developed entirely in the Linux terminal.


## Requirements

- Linux terminal  
- [Conda](https://docs.conda.io/en/latest/)  
- [NCBI Entrez Direct / datasets](https://www.ncbi.nlm.nih.gov/books/NBK179288/)  
- [MUSCLE](https://www.drive5.com/muscle/)  
- [RAxML](https://cme.h-its.org/exelixis/web/software/raxml/)  
- [HyPhy](https://github.com/veg/hyphy)  
- [iTOL](https://itol.embl.de/) (for tree visualization)


## Usage

Run the main pipeline (example with SRC):

```bash
bash deciphering_bird_cancer.sh
```
Modify the NCBI download command inside the script to analyze other genes.

Optional: Run Specific HyPhy Analyses
You can run the selection analyses individually using HyPhy:

1. MEME (Detect sites under positive selection):

```bash
hyphy LIBPATH=/home/manager/anaconda3/lib/hyphy meme \
      --alignment SRCmuscleAlignMod2.afa \
      --tree RAxML_bestTree.SRCraxml_trees \
      --output /home/manager/Results/MEME_Sites/hyphySRC_meme.json
```
2. aBSREL (Detect branches under positive selection):

```bash
hyphy LIBPATH=/home/manager/anaconda3/lib/hyphy absrel \
      --alignment SRCmuscleAlignMod2.afa \
      --tree RAxML_bestTree.SRCraxml_trees \
      --branches All \
      --output /home/manager/Results/aBSREL_Branches/hyphySRC_absrel.json
```
Note: The output JSON files can be viewed in HyPhy Vision: http://vision.hyphy.org
Adjust paths if your working directories are different.

## Example Results
- Multiple sequence alignment of SRC
- Maximum likelihood phylogenetic tree
- HyPhy outputs in JSON format (sites and branches under positive selection)

## Notes
- The pipeline is designed for Linux terminal usage.
- Sequence headers are cleaned to remove extra characters, and stop codons are removed using HyPhy clean (cln).
- The pipeline can be adapted to analyze other proto-oncogenes or coding sequences.