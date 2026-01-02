# Author: James Ashmore
# Copyright: Copyright 2020, James Ashmore
# Email: jma1991@icloud.com
# License: MIT

plotRLE <- function(object, ...) {

    UseMethod("plotRLE")

}

plotRLE.ExpressionSet <- function(object, col) {

    mat <- exprs(object)

    med <- apply(mat, 1, median, na.rm = TRUE)

    M <- mat - med

    d <- data.frame(
        x = as.vector(M), 
        y = colnames(M)[col(M)], 
        i = pData(object)[, col][col(M)]
    )

    l <- quantile(d$x, c(0.01, 0.99))

    p <- ggplot(d, aes(x, y, fill = i)) + 
        geom_boxplot(coef = Inf) + 
        scale_x_continuous(limits = l) + 
        labs(x = "RLE", y = "Array", fill = NULL) + 
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

    p <- plotRLE(x, col = params$col)

    ggsave(output$pdf, plot = p)


}

main(snakemake@input, snakemake@output, snakemake@params, snakemake@log)