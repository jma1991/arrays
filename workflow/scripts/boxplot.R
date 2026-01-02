# Author: James Ashmore
# Copyright: Copyright 2020, James Ashmore
# Email: jma1991@icloud.com
# License: MIT

boxplot <- function(object, col) {

    UseMethod("boxplot")

}

boxplot.ExpressionSet <- function(object, col) {

    m <- exprs(object)

    d <- data.frame(
        x = as.vector(m), 
        y = colnames(m)[col(m)], 
        i = pData(object)[, col][col(m)]
    )

	p <- ggplot(d, aes(x, y, fill = i)) + 
        geom_boxplot(coef = Inf) + 
        labs(x = "Intensity", y = "Array", fill = NULL) + 
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

	p <- boxplot(x, col = params$col)

	ggsave(output$pdf, plot = p)

}

main(snakemake@input, snakemake@output, snakemake@params, snakemake@log)