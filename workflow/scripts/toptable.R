# Author: James Ashmore
# Copyright: Copyright 2020, James Ashmore
# Email: james.ashmore@zifornd.com
# License: MIT

main <- function(input, output, params, log) {

    # Log

    out <- file(log$out, open = "wt")

    err <- file(log$err, open = "wt")

    sink(out, type = "output")

    sink(err, type = "message")

    # Script

    library(limma)

    fit <- readRDS(input$rds)

    con <- paste(params[["contrast"]], collapse = "-")

    res <- topTable(fit, coef = con, number = Inf, sort.by = "none")

    write.table(res, file = output$tsv, quote = FALSE, sep = '\t', row.names = FALSE)

}

main(snakemake@input, snakemake@output, snakemake@params, snakemake@log)