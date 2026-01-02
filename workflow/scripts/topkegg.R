# Author: James Ashmore
# Copyright: Copyright 2020, James Ashmore
# Email: jma1991@icloud.com
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

    x <- subset(x, !is.na(Pathway)) # NA in Pathway column triggers error in topKEGG
    
    x <- topKEGG(x, number = params$number, truncate.path = 50L)
    
    x$P <- pmin(x$P.Up, x$P.Down)
    
    i <- which.pmin(x$P.Up, x$P.Down)
    
    x$Direction <- c("Up", "Down")[i]
    
    p <- ggplot(x, aes(-log10(P), reorder(Pathway, -P), colour = Direction)) + 
        geom_point() + 
        geom_segment(aes(x = 0, xend = -log10(P), y = reorder(Pathway, -P), yend = reorder(Pathway, -P))) + 
        labs(x = expression("-Log"[10]*"("*italic(p)*"-value)"), y = "Pathway") +
        theme_bw()

    h <- params$number * 0.25

    ggsave(output$pdf, plot = p, width = 8, height = h, scale = 0.8)

}

main(snakemake@input, snakemake@output, snakemake@params, snakemake@log)
