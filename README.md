# Arrays <img align="right" width="200" src="images/roundel.png">

A Snakemake workflow to analyse Affymetrix expression arrays

![GitHub Actions: CI](https://github.com/zifornd/array/actions/workflows/main.yml/badge.svg)
[![License: MIT](https://img.shields.io/badge/License-MIT-green.svg)](https://opensource.org/licenses/MIT)

## Contents

* [Overview](#overview)
* [Installation](#installation)
* [Usage](#usage)
* [Documentation](#documentation)
* [Contributing](#contributing)
* [Authors](#authors)
* [Citation](#citation)
* [Acknowledgements](#acknowledgements)
* [License](#license)

## Overview

This workflow is used to analyse Affymetrix expression arrays at the probe level. It performs quality control, differential expression analysis, and gene set testing. Batch correction and blocking are also implemented. Any expression array which has a Bioconductor annotation package is supported.

## Installation

Install Snakemake using the conda package manager:

```console
$ conda create -c bioconda -c conda-forge --name snakemake snakemake
```

Deploy the workflow to your project directory:

```console
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
$ snakemake --cores all --use-conda 
```

## Documentation

See the [Documentation](workflow/documentation.md) file for all configuration, execution, and output information.

## Contributing

See the [Contributing](CONTRIBUTING.md) file for ways to get started.

Please adhere to this project's [Code of Conduct](CODE_OF_CONDUCT.md).

## Authors

This workflow was developed by:

- [James Ashmore](https://github.com/james-ashmore)

## Citation

See the [Citation](CITATION.cff) file for ways to cite this workflow.

## Acknowledgements

This workflow is based on the following research article:

```
Klaus B and Reisenauer S. An end to end workflow for differential gene expression using Affymetrix microarrays [version 2; peer review: 2 approved]. F1000Research 2018, 5:1384 (https://doi.org/10.12688/f1000research.8967.2)
```

## License

This workflow is licensed under the [MIT](LICENSE.md) license.  
Copyright &copy; 2021, Zifo RnD Solutions
