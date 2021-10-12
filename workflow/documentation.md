# Documentation

Welcome to the workflow documentation!

## Contents

* [Introduction](#overview)
* [Usage](#execution)
* [Configuration](#configuration)
* [Output](#results)
* [Tests](#test)
* [FAQ](#faq)
* [References](#references)

## Introduction

This repository contains a Snakemake workflow to analyze oligonucleotide arrays (expression/SNP/tiling/exon) at the probe level. It currently supports Affymetrix (CEL files) and NimbleGen arrays (XYS files).

## Usage

The workflow can be executed using the following command:

```console
$ snakemake --cores all --use-conda
```

This will use all available cores and deploy software dependencies via the conda
package manager. For further information, please refer to the official
[Snakemake](https://snakemake.readthedocs.io/en/stable/index.html)
documentation.

### Update the workflow

Use git to pull the latest release:

   ```console
   $ git pull
   ```

## Configuration

The workflow is configured by editing the configuration files:

- `config/config.yaml` 
- `config/samples.tsv`

### Workflow config

The workflow config is a YAML file containing information about the workflow
parameters:

* Each line contains a name:value pair
* Each name:value pair corresponds to a workflow parameter

The workflow config must contain the following fields:

| Name | Description | Example |
| --- | --- | --- |
| samples | Path to sample sheet | config/samples.tsv |
| platform | Bioconductor platform data package | pd.hugene.1.0.st.v1 |
| annotation | Bioconductor annotation data package  | hugene10sttranscriptcluster.db |
| organism | Bioconductor organism data package | org.Hs.eg.db |
| contrasts | Specified contrasts | GRCh38.p13 |


Contrasts for the differential expression analysis are defined

```yaml
contrasts:
    treatment-control:
        - treatment
        - control
```

Example of a valid workflow config:

```yaml
samples: config/samples.csv
platform: pd.hugene.1.0.st.v1
annotation: hugene10sttranscriptcluster.db
organism: org.Hs.eg.db
contrasts:
    treatment-control:
        - treatment
        - control
```

### Sample table

The sample table is a TSV file containing information about the samples in your experiment:

* Each row corresponds to one sample
* Each column corresponds to one attribute

For each sample, you must provide the following:

| Column | Description | Example |
| --- | --- | --- |
| sample | Sample name | "S1" |
| condition | Condition | "treatment" |
| filename | Array file | "S1.CEL" |

For each example, you

| Column | Description | Example |
| --- | --- | --- |
| batch | Batch | "S1" |
| block | Block | "patient" |


Example of a valid sample table:

```
sample  condition   filename batch  block
S1      C           S1.CEL   A      A   
S2      C           S2.CEL   A      B
S3      C           S1.CEL   B      C
S4      T           S2.CEL   A      A
S5      T           S3.CEL   A      B
S6      T           S4.CEL   B      C
```

## Results

### Directory

The workflow writes all outputs files to the `results` directory.

```console
results
├── annotate.rds
├── boxplot.pdf
├── {contrast}.goana.tsv
├── {contrast}.heatmap.pdf
├── {contrast}.kegga.tsv
├── {contrast}.pvalue.pdf
├── {contrast}.topgo.pdf
├── {contrast}.topkegg.pdf
├── {contrast}.toptable.tsv
├── {contrast}.volcano.pdf
├── annotate.rds
├── boxplot.pdf
├── correct.rds
├── dens.pdf
├── filter.rds
├── hm.pdf
├── import.rds
├── ma.pdf
├── mds.pdf
├── model.rds
├── msd.pdf
├── normalize.rds
├── pca.pdf
└── rle.pdf
```

### Files

| File | Format | Description |
| --- | --- | --- |
| `import.rds` | RDS | ExpressionFeatureSet object |
| `normalize.rds` | RDS | ExpressionSet object |
| `annotate.rds` | RDS | Annotated ExpressionSet object |
| `filter.rds` | RDS | Filtered ExpressionSet object |

Quality control:

| File | Format | Description |
| --- | --- | --- |
| `box.pdf` | PDF | Boxplot of intensity values |
| `dens.pdf` | PDF | Density of intensity values |
| `hm.pdf` | PDF | Heatmap of array distances |
| `ma.pdf` | PDF | MA plot |
| `mds.pdf` | PDF | Multidimensional scaling plot |
| `msd.pdf` | PDF | Spliced genes |
| `pca.pdf` | PDF | Principal components analysis |
| `rle.pdf` | PDF | Relative log expression |

Differential expression analysis:

| File | Format | Description |
| --- | --- | --- |
| `{contrast}.toptable.tsv` | TSV | Test results |
| `{contrast}.pvalue.pdf` | PDF | Histogram of p-values |
| `{contrast}.volcano.pdf` | PDF | Volcano plot |
| `{contrast}.heatmap.pdf` | PDF | Heatmap of gene expression |
| `{contrast}.goana.tsv` | TSV | Table of over-represented GO terms |
| `{contrast}.topgo.pdf` | PDF | Plot of over-represtend GO terms |
| `{contrast}.kegga.tsv` | TSV | Table of over-represented KEGG pathways |
| `{contrast}.topkegg.pdf` | PDF | Plot of over-represented KEGG pathways |

## Tests

Test cases are in the `.test` directory. They are automatically executed via continuous integration with GitHub Actions.

## FAQ

### How do I know which Bioconductor packages to use?

Navigate to the [Bioconductor Annotation Packages](https://www.bioconductor.org/packages/release/data/annotation/) page and search for the matching platform, annotation, and organism packages.

For example, an experiment which uses the Human Genome U133 Plus 2.0 Array requires the following packages:

```yaml
organism: org.Hs.eg.db
platform: pd.hg.u133.plus.2
annotation: hgu133plus2.db
```

### How do I remove batch effects from the expression data?

To remove batch effects, specify a batch column in the sample table.

Batch effects are removed from the expression data using the *removeBatchEffect* function from the limma Bioconductor package.

Importantly, the batch-free expression data is not used for differential expression analysis. Instead, the batch factor is included in the design matrix.

```shell
sample  condition   filename    batch
S1      C           S1.CEL      A
S2      C           S2.CEL      A
S3      C           S3.CEL      B
S4      T           S4.CEL      A
S5      T           S5.CEL      A
S6      T           S6.CEL      B
```

### How do I include blocking in the experimental design?

To include a blocking factor, specify a block column in the sample table. For example:

```shell
sample  condition   filename    block
S1      C           S1.CEL      A
S2      C           S2.CEL      B
S3      C           S3.CEL      C
S4      T           S4.CEL      A
S5      T           S5.CEL      B
S6      T           S6.CEL      C
```

## References

This workflow relies on multiple open-source software. Please give appropriate credit by citing them in any

### Bioconductor

- AnnotationDbi
- GO.db
- limma
- oligo

### CRAN

  - ggforce
  - ggplot2
  - ggrepel
  - hexbin
  - matrixstats
  - pheatmap
  - RColorBrewer
  - reshape2
