# Author: James Ashmore
# Copyright: Copyright 2020, James Ashmore
# Email: james.ashmore@zifornd.com
# License: MIT

rule import:
    input:
        tsv = config["samples"],
        pkg = expand("resources/bioconductor/platform/lib/R/library/{package}", package = config["platform"])
    output:
        rds = "results/import.rds"
    params:
        platform = config["platform"]
    log:
        out = "logs/import.out",
        err = "logs/import.err"
    message:
        "Read CEL files"
    conda:
        "../envs/environment.yaml"
    script:
        "../scripts/import.R"

rule normalize:
    input:
        rds = "results/import.rds",
        pkg = expand("resources/bioconductor/platform/lib/R/library/{package}", package = config["platform"])
    output:
        rds = "results/normalize.rds"
    params:
        platform = config["platform"]
    log:
        out = "logs/normalize.out",
        err = "logs/normalize.err"
    message:
        "Perform background correction, normalization and summarization"
    conda:
        "../envs/environment.yaml"
    script:
        "../scripts/normalize.R"

rule annotate:
    input:
        rds = "results/normalize.rds",
        pkg = [
            expand("resources/bioconductor/annotation/lib/R/library/{package}", package = config["annotation"]),
            expand("resources/bioconductor/organism/lib/R/library/{package}", package = config["organism"])
        ]
    output:
        rds = "results/annotate.rds"
    params:
        annotation = config["annotation"],
        organism = config["organism"]
    log:
        out = "logs/annotate.out",
        err = "logs/annotate.err"
    message:
        "Annotate the transcript clusters"
    conda:
        "../envs/environment.yaml"
    script:
        "../scripts/annotate.R"

rule filter:
    input:
        rds = "results/annotate.rds"
    output:
        rds = "results/filter.rds"
    params:
        group = config["filter"]["group"],
        exprs = config["filter"]["exprs"]
    log:
        out = "logs/filter.out",
        err = "logs/filter.err"
    message:
        "Filter control, non-unique, and unexpressed probes"
    conda:
        "../envs/environment.yaml"
    script:
        "../scripts/filter.R"

rule correct:
    input:
        rds = "results/filter.rds",
    output:
        rds = "results/correct.rds"
    log:
        out = "logs/correct.out",
        err = "logs/correct.err"
    message:
        "Perform batch correction"
    conda:
        "../envs/environment.yaml"
    script:
        "../scripts/correct.R"
