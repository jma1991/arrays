# Author: James Ashmore
# Copyright: Copyright 2020, James Ashmore
# Email: jma1991@icloud.com
# License: MIT

main <- function(input, output, params, log) {
    # Log

    out <- file(log$out, open = "wt")

    err <- file(log$err, open = "wt")

    sink(out, type = "output")

    sink(err, type = "message")

    # Script

    library(oligo)

    library(
        params$platform,
        character.only = TRUE,
        lib.loc = "resources/bioconductor/platform/lib/R/library"
    )

    obj <- readRDS(input$rds)

    obj <- rma(obj)

    saveRDS(obj, file = output$rds)
}

main(snakemake@input, snakemake@output, snakemake@params, snakemake@log)
