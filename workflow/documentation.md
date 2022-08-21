# Documentation

## Table of Contents

* [Introduction](#overview)
* [Usage](#execution)
* [Configuration](#configuration)
* [Results](#results)
* [Tests](#test)
* [FAQ](#faq)
* [References](#references)

## Introduction

This repository contains a Snakemake workflow to analyze expression arrays at the probe level.

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

Update the workflow to the latest version using the command shown below:

```console
$ git pull
```

## Configuration

The workflow is configured by editing the following files:

- `config/config.yaml` 
- `config/samples.tsv`

An error will be thrown if these files are missing or not formatted correctly.

### Workflow config

The workflow config is a YAML file containing information about the workflow
parameters:

* Each line contains a name-value pair
* Each name-value pair corresponds to a workflow parameter

The workflow config must contain the following pairs:

| Name | Value | Example |
| --- | --- | --- |
| samples | Path to sample sheet | config/samples.tsv |
| platform | Bioconductor platform data package | pd.hugene.1.0.st.v1 |
| annotation | Bioconductor annotation data package  | hugene10sttranscriptcluster.db |
| organism | Bioconductor organism data package | org.Hs.eg.db |
| contrasts | Contrast name and conditions in sample table | treatment-control |

Contrasts for differential expression analysis are defined as shown below:

```yaml
contrasts:
    treatment-control:
        - treatment
        - control
```

Below is an example of a valid workflow config:

```yaml
samples: config/samples.tsv
platform: pd.hugene.1.0.st.v1
annotation: hugene10sttranscriptcluster.db
organism: org.Hs.eg.db
contrasts:
    treatment-control:
        - treatment
        - control
```

For this example, the workflow will install the platform, annotation, and organism Bioconductor packages and run a differential expression analysis on the treatment versus control conditions.

### Sample table

The sample table is a TSV file containing data on the experimental design:

* Each row corresponds to one sample
* Each column corresponds to one attribute

For each sample, you must provide the following columns:

| Column | Description | Example |
| --- | --- | --- |
| sample | Sample name | S1 |
| condition | Condition | treatment |
| celfile | Array file | S1.CEL |

To incorporate batch effects and blocking, you must add the following columns:

| Column | Description | Example |
| --- | --- | --- |
| batch | Batch effect | S1-B1 |
| block | Sample pairing | S1-P1 |

Below is an example of a valid sample table:

```
sample  condition   celfile batch  block
S1      C           S1.CEL   A      A   
S2      C           S2.CEL   A      B
S3      C           S1.CEL   B      C
S4      T           S2.CEL   A      A
S5      T           S3.CEL   A      B
S6      T           S4.CEL   B      C
```

Missing values can be specified by empty columns or by writing `NA` in the relevent entry.

## Results

The workflow writes all output files to the `results` directory. This directory
is created upon execution and has the following layout:

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

The output files are named after each rule in the workflow. Any
contrast-specific files are prefixed with the contrast name. See below for an
explanation of each output file:

### Pre-processing


| File | Format | Description |
| --- | --- | --- |
| `import.rds` | RDS | ExpressionFeatureSet object |
| `normalize.rds` | RDS | ExpressionSet object |
| `annotate.rds` | RDS | Annotated ExpressionSet object |
| `filter.rds` | RDS | Filtered ExpressionSet object |

### Quality control

| File | Format | Description |
| --- | --- | --- |
| `box.pdf` | PDF | Boxplot of expression values |
| `dens.pdf` | PDF | Density plot of expression values |
| `hm.pdf` | PDF | Heatmap of array distances |
| `ma.pdf` | PDF | MA plot |
| `mds.pdf` | PDF | Multidimensional scaling plot |
| `msd.pdf` | PDF | Mean vs standard deviation |
| `pca.pdf` | PDF | Principal components analysis |
| `rle.pdf` | PDF | Relative log expression |

### Differential expression analysis

| File | Format | Description |
| --- | --- | --- |
| `{contrast}_toptable.tsv` | TSV | Test results |
| `{contrast}_pvalue.pdf` | PDF | Histogram of p-values |
| `{contrast}_volcano.pdf` | PDF | Volcano plot |
| `{contrast}_heatmap.pdf` | PDF | Heatmap of gene expression |

### Gene set analysis

| File | Format | Description |
| --- | --- | --- |
| `{contrast}_goana.tsv` | TSV | Table of over-represented GO terms |
| `{contrast}_topgo.pdf` | PDF | Plot of over-represtend GO terms |
| `{contrast}_kegga.tsv` | TSV | Table of over-represented KEGG pathways |
| `{contrast}_topkegg.pdf` | PDF | Plot of over-represented KEGG pathways |

## Tests

Test cases are in the `.test` directory. They are automatically executed via
continuous integration with GitHub Actions.

## FAQ

### How do I know which Bioconductor packages to use?

Navigate to the [Bioconductor Annotation
Packages](https://www.bioconductor.org/packages/release/data/annotation/) page
and search for the matching platform, annotation, and organism packages.

For example, an experiment which uses the Human Genome U133 Plus 2.0 Array
requires the following packages:

```yaml
organism: org.Hs.eg.db
platform: pd.hg.u133.plus.2
annotation: hgu133plus2.db
```

### How do I remove batch effects from the expression data?

To remove batch effects, specify a batch column in the sample table.

Batch effects are removed from the expression data using the *removeBatchEffect*
function from the limma Bioconductor package.

Importantly, the batch-free expression data is not used for differential
expression analysis. Instead, the batch factor is included in the design matrix.

```shell
sample  condition   celfile    batch
S1      C           S1.CEL      A
S2      C           S2.CEL      A
S3      C           S3.CEL      B
S4      T           S4.CEL      A
S5      T           S5.CEL      A
S6      T           S6.CEL      B
```

### How do I include blocking in the experimental design?

To include a blocking factor in the experimental design, include a block column
in the sample table. This can be used to account for designs such as paired samples. For example:

```shell
sample  condition   celfile    block
S1      C           S1.CEL      A
S2      C           S2.CEL      B
S3      C           S3.CEL      C
S4      T           S4.CEL      A
S5      T           S5.CEL      B
S6      T           S6.CEL      C
```

## References

This workflow relies on multiple open-source software. Please give appropriate
credit by citing them in any pubished work:

###

- Snakemake - Mölder, F., Jablonski, K.P., Letcher, B., Hall, M.B., Tomkins-Tinch, C.H., Sochat, V., Forster, J., Lee, S., Twardziok, S.O., Kanitz, A., Wilm, A., Holtgrewe, M., Rahmann, S., Nahnsen, S., Köster, J., 2021. Sustainable data analysis with Snakemake. F1000Res 10, 33



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
