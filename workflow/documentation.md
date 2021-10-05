# Documentation

Welcome to the workflow documentation

## Contents

* [Introduction](#overview)
* [Usage](#execution)
* [Configuration](#configuration)
* [Output](#results)
* [Tests](#test)
* [FAQ](#faq)
* [References](#references)

## Introduction

Chromium is a Snakemake workflow to analyze oligonucleotide arrays (expression/SNP/tiling/exon) at the probe level. It currently supports Affymetrix (CEL files) and NimbleGen arrays (XYS files).

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

Oligo is configured by editing the files in the config directory:

- config.yaml 
- samples.tsv

An error will be thrown if these files are missing or do not contain the
required information.

### Workflow config

The workflow config is a YAML file containing information about the workflow
parameters:

* each line contains a name:value pair
* each name:value pair corresponds to a workflow parameter

The workflow config must contain the following:

| Name | Description | Example |
| --- | --- | --- |
| samples | Path to samples.csv | config/samples.csv |
| platform | Microarray platformn | "pd.hugene.1.0.st.v1" |
| annotation | Annotation name | "hugene10sttranscriptcluster.db" |
| organism | Organism name | 101 |
| contrasts | Contrasts | GRCh38.p13 |

Example of a valid workflow config:

```yaml
samples: "config/samples.csv"
platform: "pd.hugene.1.0.st.v1"
annotation: "hugene10sttranscriptcluster.db"
organism: "Homo sapiens"
contrasts:
    A_vs_B:
        - A
        - B
```

### Samples table

The samples table is a TSV file containing information about the biological replicates in your experiment:

* each row corresponds to one sample
* each column corresponds to one attribute

For each sample, you must provide the following:

| Column | Description | Example |
| --- | --- | --- |
| sample | Sample name | "S1" |
| condition | Condition | "treatment" |
| file | Array file | "S1.CEL" |

Example of a valid samples table:

```
sample,condition,file
S1,control,S1.CEL
S2,control,S2.CEL
S3,treatment,S3.CEL
S4,treatment,S4.CEL
```

## Output

Oligo analyzes the oligonucleotide arrays using:

* kallisto|bustools
* Alevin
* STARsolo

For each method, all output files are saved to disk and a SingleCellExperiment  
object containing spliced and unspliced count matrices is generated.

### Results directory

Chromium saves all results files in the `results` directory.

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
├── {contrast}.tsv
├── {contrast}.volcano.pdf
├── dens.pdf
├── filtered.rds
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

### Results files

Pre-processing:

| File | Format | Description |
| --- | --- | --- |
| `import.rds` | RDS | R object |
| `normalize.rds` | RDS | R object |

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

Post-processing:

| File | Format | Description |
| --- | --- | --- |
| `filter.rds` | RDS | R object |
| `annotate.rds` | RDS | R object |
| `model.rds` | RDS | R object |

For each contrast, the following results files are created:

| File | Format | Description |
| --- | --- | --- |
| `{contrast}.toptable.tsv` | TSV | Corrected BUS file |
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

#### Which quantification workflow should I use?

I would suggest there is no best workflow, each one captures a unique aspect of the data by the counting strategies they have implemented. For a more in-depth discussion, please refer to this research article by Soneson and colleagues: https://doi.org/10.1371/journal.pcbi.1008585

#### What reference genomes are supported?

The workflow uses genomepy and gffread to download and parse the user-specified reference genome and annotation. Therefore, any genome release compatible with these software should be supported.

#### How do I combine multiple sequencing runs?

If the sequencing runs were performed across multiple lanes on the same date, it is unlikely that a batch effect is present and I would recommend quantifying the files all together. Below is an example units table showing how to specify multiple sequencing runs jointly for a given sample: 

```
sample,unit,read1,read2
S1,L001,S1_L001.fastq.gz,S1_L001.fastq.gz
S1,L002,S1_L002.fastq.gz,S1_L002.fastq.gz
```

Alternatively, if the sequencing runs were performed on different machines and different dates, there is potential for a batch effect and I would recommend quantifying the files separately until this can be investigated. Below is an example units table showing how to specify multiple sequencing runs independently for a given sample:

```
sample,unit,read1,read2
S1_L001,L001,S1_L001.fastq.gz,S1_L001.fastq.gz
S1_L002,L002,S1_L002.fastq.gz,S1_L002.fastq.gz
```


## References

This workflow relies on multiple open-source software. Please give appropriate credit
by citing them in your publication:

- [oligo]

Carvalho and Irizarry. A Framework for Oligonucleotide Microarray Preprocessing. Bioinformatics
(2010) vol. 16 (19) pp. 2363-2367.



- [limma]

Ritchie, ME, Phipson, B, Wu, D, Hu, Y, Law, CW, Shi, W, and Smyth, GK (2015). limma powers differential expression analyses for RNA-sequencing and microarray studies. Nucleic Acids Research 43(7), e47.

Phipson, B, Lee, S, Majewski, IJ, Alexander, WS, and Smyth, GK (2016). Robust hyperparameter estimation protects against hypervariable genes and improves power to detect differential expression. Annals of Applied Statistics 10(2), 946–963.



[**Alevin**](https://doi.org/10.1186/s13059-019-1670-y)  
Srivastava, A., Malik, L., Smith, T. et al. Alevin efficiently estimates accurate gene abundances from dscRNA-seq data. Genome Biol 20, 65 (2019).

[**Anaconda**](https://anaconda.com)  
Anaconda Software Distribution. Computer software. Vers. 2-2.4.0. Anaconda, Nov. 2016. Web.

[**BUSpaRse**](https://bioconductor.org/packages/BUSpaRse/)  
Moses L, Pachter L (2021). BUSpaRse: kallisto | bustools R utilities. R package version 1.4.2.

[**BUStools**](https://doi.org/10.1038/s41587-021-00870-2)  
Melsted, P., Booeshaghi, A.S., Liu, L. et al. Modular, efficient and constant-memory single-cell RNA-seq preprocessing. Nat Biotechnol (2021).

[**Bioconda**](https://doi.org/10.1038/s41592-018-0046-7)  
Grüning, B., Dale, R., Sjödin, A. et al. Bioconda: sustainable and comprehensive software distribution for the life sciences. Nat Methods 15, 475–476 (2018).

[**eisaR**](https://bioconductor.org/packages/eisaR/)  
Stadler MB, Gaidatzis D, Burger L, Soneson C (2020). eisaR: Exon-Intron Split Anaalysis (EISA) in R. R package version 1.0.

[**genomepy**](http://dx.doi.org/10.21105/joss.00320)  
Heeringen, (2017), genomepy: download genomes the easy way, Journal of Open Source Software, 2(16), 320.

[**GffRead**](https://doi.org/10.12688/f1000research.23297.2)  
Pertea G and Pertea M. GFF Utilities: GffRead and GffCompare [version 2; peer review: 3 approved]. F1000Research 2020, 9:304.

[**Kallisto**](https://doi.org/10.1038/nbt.3519)  
Bray, N., Pimentel, H., Melsted, P. et al. Near-optimal probabilistic RNA-seq quantification. Nat Biotechnol 34, 525–527 (2016).

[**Python**](https://www.python.org/)  
Python Core Team (2015). Python: A dynamic, open source programming language.
Python Software Foundation.

[**R**](https://www.R-project.org/)  
R Core Team (2020). R: A language and environment for statistical computing. R Foundation for Statistical Computing, Vienna, Austria.

[**STAR**](https://doi.org/10.1101/2021.05.05.442755)  
Alexander Dobin, Carrie A. Davis, Felix Schlesinger, Jorg Drenkow, Chris Zaleski, Sonali Jha, Philippe Batut, Mark Chaisson, Thomas R. Gingeras, STAR: ultrafast universal RNA-seq aligner, Bioinformatics, Volume 29, Issue 1, January 2013, Pages 15–21.

[**SingleCellExperiment**](https://doi.org/10.1038/s41592-019-0654-x)  
Amezquita, R.A., Lun, A.T.L., Becht, E. et al. Orchestrating single-cell analysis with Bioconductor. Nat Methods 17, 137–145 (2020).

[**Snakemake**](https://doi.org/10.12688/f1000research.29032.2)  
Mölder F, Jablonski KP, Letcher B et al. Sustainable data analysis with Snakemake [version 2; peer review: 2 approved]. F1000Research 2021, 10:33.