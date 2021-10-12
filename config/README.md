# Configuration

The workflow is configured by editing the following files:

- `config/config.yaml` 
- `config/samples.tsv`

An error will be thrown if these files are missing or not formatted correctly.

## Workflow config

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

## Sample table

The sample table is a TSV file containing data on the experimental design:

* Each row corresponds to one sample
* Each column corresponds to one attribute

For each sample, you must provide the following columns:

| Column | Description | Example |
| --- | --- | --- |
| sample | Sample name | S1 |
| condition | Condition | treatment |
| filename | Array file | S1.CEL |

To incorporate batch effects and blocking, you must add the following columns:

| Column | Description | Example |
| --- | --- | --- |
| batch | Batch effect | S1-B1 |
| block | Sample pairing | S1-P1 |

Below is an example of a valid sample table:

```
sample  condition   filename batch  block
S1      C           S1.CEL   A      A   
S2      C           S2.CEL   A      B
S3      C           S1.CEL   B      C
S4      T           S2.CEL   A      A
S5      T           S3.CEL   A      B
S6      T           S4.CEL   B      C
```

Missing values can be specified by empty columns or by writing `NA` in the relevent entry.