# Author: James Ashmore
# Copyright: Copyright 2020, James Ashmore
# Email: jma1991@icloud.com
# License: MIT

rule goana:
    input:
        rds = "results/model.rds",
        pkg = expand("resources/bioconductor/organism/lib/R/library/{package}", package = config["organism"])
    output:
        tsv = report("results/{contrast}.goana.tsv", caption = "../report/goana.rst", category = "Gene Set Tests", subcategory = "{contrast}")
    params:
        contrast = get_contrast,
        FDR = 0.05,
        organism = config["organism"]
    log:
        out = "logs/{contrast}.goana.out",
        err = "logs/{contrast}.goana.err"
    message:
        "Test over-representation of GO terms for contrast: {wildcards.contrast}"
    conda:
        "../envs/environment.yaml"
    script:
        "../scripts/goana.R"

rule topgo:
    input:
        tsv = "results/{contrast}.goana.tsv"
    output:
        pdf = report("results/{contrast}.topgo.pdf", caption = "../report/topgo.rst", category = "Gene Set Tests", subcategory = "{contrast}")
    params:
        number = 20
    log:
        out = "logs/{contrast}.topgo.out",
        err = "logs/{contrast}.topgo.err"
    message:
        "Plot top GO terms for contrast: {wildcards.contrast}"
    conda:
        "../envs/environment.yaml"
    script:
        "../scripts/topgo.R"

rule kegga:
    input:
        rds = "results/model.rds",
        pkg = expand("resources/bioconductor/organism/lib/R/library/{package}", package = config["organism"])
    output:
        tsv = report("results/{contrast}.kegga.tsv", caption = "../report/kegga.rst", category = "Gene Set Tests", subcategory = "{contrast}")
    params:
        contrast = get_contrast,
        FDR = 0.05,
        organism = config["organism"]
    log:
        out = "logs/{contrast}.kegga.out",
        err = "logs/{contrast}.kegga.err"
    message:
        "Test over-representation of KEGG pathways for contrast: {wildcards.contrast}"
    conda:
        "../envs/environment.yaml"
    script:
        "../scripts/kegga.R"

rule topkegg:
    input:
        tsv = "results/{contrast}.kegga.tsv"
    output:
        pdf = report("results/{contrast}.topkegg.pdf", caption = "../report/topkegg.rst", category = "Gene Set Tests", subcategory = "{contrast}")
    params:
        number = 20
    log:
        out = "logs/{contrast}.topkegg.out",
        err = "logs/{contrast}.topkegg.err"
    message:
        "Plot top KEGG pathways for contrast: {wildcards.contrast}"
    conda:
        "../envs/environment.yaml"
    script:
        "../scripts/topkegg.R"
