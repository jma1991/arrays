# Author: James Ashmore
# Copyright: Copyright 2020, James Ashmore
# Email: jma1991@icloud.com
# License: MIT

lmFit <- function(object, design) {

    # Get phenotype data

    data <- pData(object)

    names <- colnames(data)

    # Set block factor

    if ("block" %in% names) {

        block <- factor(data$block)

        n.block <- nlevels(block)

        is.block <- n.block > 1

    } else {

        is.block <- FALSE

    }

    # Fit linear model ...

    if (is.block) {

        # ... with block

        output <- limma::duplicateCorrelation(object, design, block = block)

        object <- limma::lmFit(
            object      = object,
            design      = design,
            block       =  block,
            correlation = output$consensus.correlation
        )

    } else {

        # ... without block

        object <- limma::lmFit(
            object = object,
            design = design
        )

    }

    object

}

main <- function(input, output, params, log, config) {

    # Log

    out <- file(log$out, open = "wt")

    err <- file(log$err, open = "wt")

    sink(out, type = "output")

    sink(err, type = "message")

    # Script

    library(limma)

    library(oligo)

    object <- readRDS(input$rds[1])

    design <- readRDS(input$rds[2])

    contrasts <- readRDS(input$rds[3])

    object <- lmFit(object, design)

    object <- contrasts.fit(object, contrasts)

    object <- eBayes(object)

    saveRDS(object, file = output$rds)
}

main(snakemake@input, snakemake@output, snakemake@params, snakemake@log, snakemake@config)
