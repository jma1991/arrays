# Author: James Ashmore
# Copyright: Copyright 2020, James Ashmore
# Email: jma1991@icloud.com
# License: MIT


rule design:
    input:
        rds="results/filter.rds",
    output:
        rds="results/design.rds",
    log:
        out="logs/design.out",
        err="logs/design.err",
    message:
        "Create design matrix"
    conda:
        "../envs/environment.yaml"
    script:
        "../scripts/design.R"


rule contrasts:
    input:
        rds="results/filter.rds",
    output:
        rds="results/contrasts.rds",
    log:
        out="logs/contrasts.out",
        err="logs/contrasts.err",
    message:
        "Create contrasts matrix"
    conda:
        "../envs/environment.yaml"
    script:
        "../scripts/contrasts.R"


rule limma:
    input:
        rds=["results/filter.rds", "results/design.rds", "results/contrasts.rds"],
    output:
        rds="results/model.rds",
    log:
        out="logs/model.out",
        err="logs/model.err",
    message:
        "Fit linear model for each gene"
    conda:
        "../envs/environment.yaml"
    script:
        "../scripts/limma.R"


rule toptable:
    input:
        rds="results/model.rds",
    output:
        tsv=report(
            "results/{contrast}.toptable.tsv",
            caption="../report/toptable.rst",
            category="Differential Expression Analysis",
            subcategory="{contrast}",
        ),
    params:
        contrast=get_contrast,
    log:
        out="logs/{contrast}.out",
        err="logs/{contrast}.err",
    message:
        "Extract a results table for the contrast: {wildcards.contrast}"
    conda:
        "../envs/environment.yaml"
    script:
        "../scripts/toptable.R"


rule pvalue:
    input:
        tsv="results/{contrast}.toptable.tsv",
    output:
        pdf=report(
            "results/{contrast}.pvalue.pdf",
            caption="../report/pvalue.rst",
            category="Differential Expression Analysis",
            subcategory="{contrast}",
        ),
    log:
        out="logs/{contrast}.pvalue.out",
        err="logs/{contrast}.pvalue.err",
    message:
        "Plot histogram of P values for contrast: {wildcards.contrast}"
    conda:
        "../envs/environment.yaml"
    script:
        "../scripts/pvalue.R"


rule volcano:
    input:
        tsv="results/{contrast}.toptable.tsv",
    output:
        pdf=report(
            "results/{contrast}.volcano.pdf",
            caption="../report/volcano.rst",
            category="Differential Expression Analysis",
            subcategory="{contrast}",
        ),
    params:
        n=10,
        PAdj=0.05,
    log:
        out="logs/{contrast}.volcano.out",
        err="logs/{contrast}.volcano.err",
    message:
        "Plot significance versus fold change for contrast: {wildcards.contrast}"
    conda:
        "../envs/environment.yaml"
    script:
        "../scripts/volcano.R"


rule heatmap:
    input:
        rds="results/correct.rds",
        tsv="results/{contrast}.toptable.tsv",
    output:
        pdf=report(
            "results/{contrast}.heatmap.pdf",
            caption="../report/heatmap.rst",
            category="Differential Expression Analysis",
            subcategory="{contrast}",
        ),
    params:
        ntop=50,
    log:
        out="logs/{contrast}.heatmap.out",
        err="logs/{contrast}.heatmap.err",
    message:
        "Plot expression of top-ranked genes for contrast: {wildcards.contrast}"
    conda:
        "../envs/environment.yaml"
    script:
        "../scripts/heatmap.R"
