# Author: James Ashmore
# Copyright: Copyright 2020, James Ashmore
# Email: jma1991@icloud.com
# License: MIT

plotDensities <- function(object, ...) {

    UseMethod("plotDensities")

}

plotDensities.ExpressionSet <- function(object, col) {

    m <- exprs(object)

    d <- data.frame(
        x = as.vector(m), 
        i = colnames(m)[col(m)], 
        j = pData(object)[, col][col(m)]
    )

    p <- ggplot(d, aes(x, group = i, colour = j)) + 
        stat_density(geom = "line", position = "identity") + 
        labs(x = "Intensity", y = "Density", colour = NULL) + 
        theme_bw()

}

main <- function(input, output, params, log) {

    # Log

    out <- file(log$out, open = "wt")

    err <- file(log$err, open = "wt")

    sink(out, type = "output")

    sink(err, type = "message")

    # Script

    library(ggplot2)

    library(oligo)

    x <- readRDS(input$rds)

    p <- plotDensities(x, col = params$col)
    
    ggsave(output$pdf, plot = p, width = 8, height = 6, scale = 0.8)

}

main(snakemake@input, snakemake@output, snakemake@params, snakemake@log)