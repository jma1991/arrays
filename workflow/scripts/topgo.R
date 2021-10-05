# Author: James Ashmore
# Copyright: Copyright 2020, James Ashmore
# Email: james.ashmore@zifornd.com
# License: MIT

which.pmin <- function(...) unname(apply(cbind(...), 1, which.min))

main <- function(input, output, params, log) {

    # Log

    out <- file(log$out, open = "wt")

    err <- file(log$err, open = "wt")

    sink(out, type = "output")

    sink(err, type = "message")

    # Catch

    fs <- file.size(input$tsv)

    if (fs == 1) {

        file.create(output$pdf)

        return(NULL)

    }

    # Script

    library(ggplot2)

    library(limma)

    x <- read.delim(input$tsv, row.names = 1)

    x <- subset(x, !is.na(Term)) # NA in Term column triggers error in topGO
    
    x <- split(x, x$Ont)
    
    x <- lapply(x, topGO, number = params$number, truncate.term = 50L)
    
    x <- do.call(rbind, x)
    
    x$P <- pmin(x$P.Up, x$P.Down)
    
    i <- which.pmin(x$P.Up, x$P.Down)
    
    x$Direction <- c("Up", "Down")[i]
    
    p <- ggplot(x, aes(-log10(P), reorder(Term, -P), colour = Direction)) + 
        geom_point() + 
        geom_segment(aes(x = 0, xend = -log10(P), y = reorder(Term, -P), yend = reorder(Term, -P))) + 
        labs(x = expression("-Log"[10]*"("*italic(p)*"-value)"), y = "Term") +
        facet_wrap(~ Ont, ncol = 1, scales = "free") + 
        theme_bw()

    ggsave(output$pdf, plot = p)

}

main(snakemake@input, snakemake@output, snakemake@params, snakemake@log)
