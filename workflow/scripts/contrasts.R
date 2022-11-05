# Author: James Ashmore
# Copyright: Copyright 2020, James Ashmore
# Email: james.ashmore@zifornd.com
# License: MIT

# makeContrasts <- function(object) {

#     data <- pData(object)

#     condition <- factor(data$condition)

#     groups <- levels(condition)

#     combinations <- expand.grid(groups, groups)

#     contrasts <- apply(combinations, 1, paste, collapse = "-")

#     contrasts <- limma::makeContrasts(contrasts = contrasts, levels = groups)

#     contrasts <- contrasts[, colSums(contrasts != 0) > 0]
# }

makeContrasts <- function(object, config) {

    data <- pData(object)

    condition <- factor(data$condition)

    groups <- levels(condition)

    contrasts <- sapply(config$contrasts, paste, collapse = "-")

    contrasts <- limma::makeContrasts(contrasts = contrasts, levels = groups)

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

    contrasts <- makeContrasts(object, config)

    saveRDS(contrasts, file = output$rds)
}

main(snakemake@input, snakemake@output, snakemake@params, snakemake@log, snakemake@config)
