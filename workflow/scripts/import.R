# Author: James Ashmore
# Copyright: Copyright 2020, James Ashmore
# Email: james.ashmore@zifornd.com
# License: MIT

.libPaths(new = "resources/bioconductor/platform/lib/R/library")

main <- function(input, output, params, log) {

    # Log

    out <- file(log$out, open = "wt")

    err <- file(log$err, open = "wt")

    sink(out, type = "output")

    sink(err, type = "message")

    # Script

    library(oligo)

    library(params$platform, character.only = TRUE)

    df <- read.delim(input$tsv, row.names = "sample")

    pd <- AnnotatedDataFrame(df)

    es <- read.celfiles(df$filename, phenoData = pd)

    saveRDS(es, file = output$rds)

}

main(snakemake@input, snakemake@output, snakemake@params, snakemake@log)