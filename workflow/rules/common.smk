# Author: James Ashmore
# Copyright: Copyright 2020, James Ashmore
# Email: james.ashmore@zifornd.com
# License: MIT

import pandas as pd
from pathlib import Path
from snakemake.utils import validate

validate(config, schema="../schemas/config.schema.yaml")

samples = pd.read_table(config["samples"]).set_index("sample", drop=False).sort_index()
validate(samples, schema="../schemas/samples.schema.yaml")


def get_final_output():

    output = [
        "results/import.rds",
        "results/normalize.rds",
        "results/annotate.rds",
        "results/filter.rds",
        "results/correct.rds",
        "results/boxplot.pdf",
        "results/pca.pdf",
        "results/ma.png",
        "results/mds.pdf",
        "results/dens.pdf",
        "results/hm.pdf",
        "results/msd.pdf",
        "results/rle.pdf",
    ]

    contrasts = config["contrasts"]

    for contrast in contrasts:

        output.append(f"results/{contrast}.toptable.tsv")

        output.append(f"results/{contrast}.pvalue.pdf")

        output.append(f"results/{contrast}.volcano.pdf")

        output.append(f"results/{contrast}.heatmap.pdf")

        output.append(f"results/{contrast}.goana.tsv")

        output.append(f"results/{contrast}.topgo.pdf")

        output.append(f"results/{contrast}.kegga.tsv")

        output.append(f"results/{contrast}.topkegg.pdf")

    return output


def get_contrast(wildcards):
    return config["contrasts"][wildcards.contrast]
