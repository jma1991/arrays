# Author: James Ashmore
# Copyright: Copyright 2020, James Ashmore
# Email: james.ashmore@zifornd.com
# License: MIT

plotSA <- function(x) {

	UseMethod("plotSA")

}

plotSA.ExpressionSet <- function(x) {

	require("hexbin")

	E <- exprs(x)

	mu <- matrixStats::rowMeans2(E)

	sd <- matrixStats::rowSds(E)

	df <- data.frame(mean = mu, rank = rank(mu), sd = sd)

	gg <- ggplot(df, aes(rank, sd)) + geom_hex(bins = 100) + labs(x = "Mean", y = "SD")

}

main <- function(input, output, params, log) {

    # Log function

    out <- file(log$out, open = "wt")

    err <- file(log$err, open = "wt")

    sink(out, type = "output")

    sink(err, type = "message")

    # Script function

	library(ggplot2)

	library(oligo)

	x <- readRDS(input$rds)

	p <- plotSA(x)

	ggsave(output$pdf, plot = p)

}

main(snakemake@input, snakemake@output, snakemake@params, snakemake@log)