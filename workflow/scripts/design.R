# Author: James Ashmore
# Copyright: Copyright 2020, James Ashmore
# Email: jma1991@icloud.com
# License: MIT

makeDesign <- function(object) {

    # Get phenotype data

    data <- pData(object)

    names <- colnames(data)

    # Set condition factor

    if ("condition" %in% names) {

        condition <- factor(data$condition)

        n.condition <- nlevels(condition)

        is.condition <- n.condition > 1

    } else {

        is.condition <- FALSE

    }

    # Set batch factor

    if ("batch" %in% names) {

        batch <- factor(data$batch)

        n.batch <- nlevels(batch)

        is.batch <- n.batch > 1

    } else {

        is.batch <- FALSE

    }

    # Set batch2 factor

    if ("batch2" %in% names) {

        batch2 <- factor(data$batch2)

        n.batch2 <- nlevels(batch2)

        is.batch2 <- n.batch2 > 1

    } else {

        is.batch2 <- FALSE

    }

    # Construct design matrix

    if (is.condition & !is.batch & !is.batch2) {

        design <- model.matrix(~ 0 + condition)

    }

    if (is.condition & is.batch & !is.batch2) {

        design <- model.matrix(~ 0 + condition + batch)

    }

    if (is.condition & !is.batch & is.batch2) {

        design <- model.matrix(~ 0 + condition + batch2)

    }

    if (is.condition & is.batch & is.batch2) {

        design <- model.matrix(~ 0 + condition + batch + batch2)

    }

    # Rename condition coefficients

    which.condition <- seq_len(n.condition)

    colnames(design)[which.condition] <- levels(condition)

    # Return design matrix

    design

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

    object <- readRDS(input$rds)

    design <- makeDesign(object)

    saveRDS(design, file = output$rds)

}

main(snakemake@input, snakemake@output, snakemake@params, snakemake@log, snakemake@config)
