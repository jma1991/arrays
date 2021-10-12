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
* [Documentation](#documentation)
* [Contributing](#contributing)
* [Authors](#authors)
* [Tests](#tests)
* [Acknowledgements](#acknowledgements)
* [License](#license)

## Overview

Arrays is a Snakemake workflow to analyze Affymetrix gene expression arrays. It performs



It currently supports Affymetrix CEL files.

## Installation

Arrays can be installed via the mamba package manager:



```console
# Install Snakemake
$ mamba create -c bioconda -c conda-forge --name snakemake snakemake

# Activate Snakemake environment
$ mamba activate snakemake

# Create project directory
$ mkdir project

# Download workflow to project directory
$ git pull https://github.com/zifornd/array project
```

## Usage







```console
# Configure workflow
$ nano config/config.yaml

# Define samples
$ nano config/samples.csv

# Test configuration
$ snakemake -n

# Execute workflow
$ snakemake --cores all --use-conda
```

## Deployment

TODO: Suman Ghosh

## Documentation

See the [`documentation.md`](workflow/documentation.md) file for the full documentation

## Support

If you need support, open an issue with one of the labels:

- help wanted (extra attention is needed)
- question (further information is requested)

## Feedback

If you have feedback, open an issue with one of the labels:

- documentation (improvements or additions to documentation)
- enhancement (new feature or request)

## Contributing

Contributions are always welcome!

See `contributing.md` for ways to get started.

Please adhere to this project's `code of conduct`.

## Authors

- [James Ashmore](https://www.github.com/james-ashmore)

## Citation

If you use Arrays in your research or commerical work, please cite using the DOI: [10.5281/zenodo.4783308](https://doi.org/10.5281/zenodo.4783309)


## Used By

Arrays is used by the following companies and institutes:

- [Zifo RnD Solutions](zifornd.com)

If you would like to be added to this list, please open a [pull request](https://github.com/jma1991/scrnaseq/pulls) with your information.

## Acknowledgements

This workflow was developed according to the research article:

> Klaus B and Reisenauer S. An end to end workflow for differential gene expression using Affymetrix microarrays [version 2; peer review: 2 approved]. F1000Research 2018, 5:1384 (https://doi.org/10.12688/f1000research.8967.2)


## License

This workflow is licensed under the [MIT](LICENSE.md) license.  
Copyright &copy; 2020, Zifo RnD Solutions