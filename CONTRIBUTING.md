# Contributing

Thank you for reading this guide and considering a contribution!

## Table of Contents

A table of contents is listed below:

* [Support](#support)
* [Feedback](#feedback)
* [Testing](#testing)
* [Formatting](#formatting)
* [Conduct](#conduct)

## Support

If you need any help getting started or solving an error:

1. Read the full documentation and identify the relevent section
2. Search the issues tracker for similar problems and solutions
3. Open an issue with one of the following labels:
	- `help wanted` for when extra attention is needed
	- `question` for when further information is requested

## Feedback

If you have any suggestions or enhancements you would like:

1. Read the full documentation to confirm your feedback is missing
2. Search the issues tracker for similar feedback and a decision
3. Open an issue with one of the following labels:
	- `documentation` for improvements or additions to documentation
	- `enhancement` for new features or requests

## Testing

Generate unit tests for your code and run the linter before opening a pull request:

```console
$ snakemake --generate-unit-tests
$ snakemake --lint
```

## Formatting

This project uses [snakefmt](https://github.com/snakemake/snakefmt) to enforce a consistent layout and style. Follow the instructions below to install and run the formatter on your code:

Install snakefmt using the conda package manager:

```console
conda install -c bioconda -n snakefmt snakefmt
```

Format a single file:

```console
snakefmt Snakefile
```

Format multiple files:

```
snakefmt workflow/
```

Importantly, contributions must pass all formatting checks before a pull request will be accepted.

## Conduct

Participation in this project is subject to a [Code of Conduct](CODE_OF_CONDUCT.md) and violations should be reported to [James Ashmore](james.ashmore@zifornd.com)