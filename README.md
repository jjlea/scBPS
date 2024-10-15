
# Overview:
This scBPS workflow is designed for calculating BPS<sub>AUC</sub> scores and p-values for single-cell RNA sequencing data. The workflow integrates GWAS-derived gene sets with single-cell RNA-seq data to identify relevant gene signatures in specific cell populations.


## How to run

```Shell
snakemake -s scBPS_workflow.smk \
    --cores N \
    --config zscore_file=<path_to_zscore_file> \
             scfile=<path_to_scfile> \
             outdir=<output_directory> \
             anno=<path_to_annotation_file> > log.txt 2>&1
```


## Example

```Shell
snakemake -s scBPS_workflow.smk \
    --cores 4 \
    --config zscore_file=test/test_gene_zscore.txt  \
             scfile=test/test_adata.h5ad \
             outdir=output \
             anno=test/cell.annotation.txt > log.txt 2>&1
```


## Parameters

`zscore_file`: This file contains two columns and is used for storing GWAS-derived top genes and their corresponding gene weights for score calculation. The two columns have the following headers: 

	`TRAIT`: The first column Represents the specific trait or phenotype from the GWAS analysis.
 
	`GENESET`: The second column contains the associated set of genes for each trait, listed in a comma-separated format.
	Each row corresponds to a specific trait and its associated gene set. 


`scfile`: This file contains single-cell RNA sequencing data in .h5ad format (AnnData). It stores gene expression information across individual cells (required), along with any associated annotations such as cell type and metadata.


`anno`: This file contains two columns and provides cell annotations for single-cell RNA sequencing data. The columns are as follows: 

	`cell_id` : The first column contains the unique cell identifier (ID) for each cell.
 
	`cell_annotation`: The second column. Each unique group in the column will be treated as a distinct cell population, which will be used to calculate the BPSAUC score and p-value. Cells that do not belong to any of the relevant or interested cell population groups should be labeled as “other” in this column.


`outdir`: This directory specifies the output location where all results will be saved.


`--cores`: The number of CPU cores to be used. 

## Outputs

`norm_score.tsv`: A tab-separated text file containing cell-wise scores for each cell across all traits.

`BPS_AUC.txt`: This file contains the calculated BPSAUC scores for all pairs of cell populations and traits. The cell populations are provided by the anno parameter (specifically, the cell_annotation column), and the traits are taken from the input zscore_file. Each row corresponds to a cell population, and each column represents a specific trait. 

`pvalue_AUC.txt`: This file contains the p-values that represent the statistical significance of the BPSAUC scores for each cell population (as defined in the cell_annotation column from the anno parameter) across all traits from the input zscore_file. Each row corresponds to a cell population, and each column represents a specific trait.



## Installation and Requirements

Before running the workflow, you need to install the required software and dependencies:

- Python 3.7+
- Snakemake
- R 4.2
- Required Python packages: `scanpy`, `scdrs`, `pandas`, `numpy`, `argparse`
- Install scBPS rpackage: `devtools::install_github("jjlea/scBPS", subdir = "rpackage")`
- Required other R packages: `DelayedArray`, `data.table`, `reshape2`, `DelayedMatrixStats`



