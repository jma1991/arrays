# Author: James Ashmore
# Copyright: Copyright 2020, James Ashmore
# Email: james.ashmore@zifornd.com
# License: MIT

rule image:
    input:
        rds = "results/import.rds",
        pkg = expand("resources/bioconductor/platform/lib/R/library/{package}", package = config["platform"])
    output:
        pdf = "results/image.pdf"
    params:
        platform = config["platform"]
    log:
        out = "logs/image.out",
        err = "logs/image.err"
    message:
        "Display a pseudo-image of the microarray chip"
    conda:
        "../envs/environment.yaml"
    script:
        "../scripts/image.R"

rule boxplot:
    input:
        rds = "results/correct.rds"
    output:
        pdf = report("results/boxplot.pdf", caption = "../report/boxplot.rst", category = "Quality Control")
    params:
        col = "condition"
    log:
        out = "logs/boxplot.out",
        err = "logs/boxplot.err"
    message:
        "Plot expression quartiles"
    conda:
        "../envs/environment.yaml"
    script:
        "../scripts/boxplot.R"

rule pca:
    input:
        rds = "results/correct.rds"
    output:
        pdf = report("results/pca.pdf", caption = "../report/pca.rst", category = "Quality Control")
    params:
        col = "condition"
    log:
        out = "logs/pca.out",
        err = "logs/pca.err"
    message:
        "Plot principal components analysis"
    conda:
        "../envs/environment.yaml"
    script:
        "../scripts/pca.R"

rule ma:
    input:
        rds = "results/correct.rds"
    output:
        pdf = report("results/ma.pdf", caption = "../report/ma.rst", category = "Quality Control")
    params:
        col = "condition"
    log:
        out = "logs/ma.out",
        err = "logs/ma.err"
    message:
        "Plot expression ratio versus average"
    conda:
        "../envs/environment.yaml"
    script:
        "../scripts/ma.R"

rule mds:
    input:
        rds = "results/correct.rds"
    output:
        pdf = report("results/mds.pdf", caption = "../report/mds.rst", category = "Quality Control")
    params:
        col = "condition"
    log:
        out = "logs/mds.out",
        err = "logs/mds.err"
    message:
        "Multi-dimensional scaling plot"
    conda:
        "../envs/environment.yaml"
    script:
        "../scripts/mds.R"

rule dens:
    input:
        rds = "results/correct.rds"
    output:
        pdf = report("results/dens.pdf", caption = "../report/dens.rst", category = "Quality Control")
    params:
        col = "condition"
    log:
        out = "logs/dens.out",
        err = "logs/dens.err"
    message:
        "Plot expression densities"
    conda:
        "../envs/environment.yaml"
    script:
        "../scripts/dens.R"

rule hm:
    input:
        rds = "results/correct.rds"
    output:
        pdf = report("results/hm.pdf", caption = "../report/hm.rst", category = "Quality Control")
    params:
        col = "condition"
    log:
        out = "logs/hm.out",
        err = "logs/hm.err"
    message:
        "Plot sample distances"
    conda:
        "../envs/environment.yaml"
    script:
        "../scripts/hm.R"

rule msd:
    input:
        rds = "results/correct.rds"
    output:
        pdf = "results/msd.pdf"
    log:
        out = "logs/msd.out",
        err = "logs/msd.err"
    message:
        "Plot expression standard deviation versus average"
    conda:
        "../envs/environment.yaml"
    script:
        "../scripts/msd.R"

rule rle:
    input:
        rds = "results/correct.rds"
    output:
        pdf = report("results/rle.pdf", caption = "../report/rle.rst", category = "Quality Control")
    params:
        col = "condition"
    log:
        out = "logs/rle.out",
        err = "logs/rle.err"
    message:
        "Plot relative log expression"
    conda:
        "../envs/environment.yaml"
    script:
        "../scripts/rle.R"
