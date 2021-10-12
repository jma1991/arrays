# Arrays

A Snakemake workflow to analyse Affymetrix expression arrays

[![Snakemake](https://img.shields.io/badge/snakemake-≥6.3.0-brightgreen.svg)](https://snakemake.github.io)
[![Snakemake-Report](https://img.shields.io/badge/snakemake-report-green.svg)](https://cdn.rawgit.com/snakemake-workflows/rna-seq-kallisto-sleuth/main/.test/report.html)
[![GitHub-Actions](https://github.com/zifornd/array/workflows/Tests/badge.svg?branch=main)](https://github.com/zifornd/array/actions?query=branch%3Amain+workflow%3ATests)
[![MIT License](https://img.shields.io/apm/l/atomic-design-ui.svg?)](https://github.com/tterb/atomic-design-ui/blob/master/LICENSEs)
  
## Contents

* [Overview](#overview)
* [Installation](#installation)
* [Usage](#usage)
* [Deployment](#deployment)
* [Documentation](#documentation)
* [Contributing](#contributing)
* [Authors](#authors)
* [Citation](#citation)
* [Partnerships](#partnerships)
* [Acknowledgements](#acknowledgements)
* [License](#license)

## Overview

This workflow is used to analyse Affymetrix expression arrays. It performs quality control, differential expression analysis, and gene set testing. See `documentation.md` for configuration, execution, and output settings.

## Installation

Install Snakemake using the conda package manager:

```console
$ conda activate base
$ conda create -c bioconda -c conda-forge --name snakemake snakemake
```

Deploy the workflow to your project directory:

```console
$ mkdir projects/arrays
$ git pull https://github.com/zifornd/arrays projects/arrays
```

## Usage

Configure the workflow by editing the `config.yaml` file:

```console
$ nano config/config.yaml
```

Define the samples by editing the `samples.tsv` file:

```console
$ nano config/samples.tsv
```

Execute the workflow and install dependencies:

```console
snakemake --cores all --use-conda 
```

## Deployment

@SumanGhosh

## Documentation

See `documentation.md` for full documentation.


## Contributing

To contribute to this workflow, clone this repository locally and commit your code on a separate branch.

Generate unit tests for your code and run the linter before opening a pull request:

```console
$ snakemake --generate-unit-tests
$ snakemake --lint
```

Participation in this project is subject to a [Code of Conduct](CODE_OF_CONDUCT.md)

## Authors

This workflow was developed by James Ashmore

## Citation

See `CITATION.cff` for ways to cite this workflow

## Partnerships

This workflow is used by the following organisations:

- Zifo RnD Solutions

## Acknowledgements

This workflow is based on the following research article:

```
Klaus B and Reisenauer S. An end to end workflow for differential gene expression using Affymetrix microarrays [version 2; peer review: 2 approved]. F1000Research 2018, 5:1384 (https://doi.org/10.12688/f1000research.8967.2)
```

## License

This workflow is licensed under the MIT license.  
Copyright &copy; 2021, Zifo RnD Solutions