# Author: James Ashmore
# Copyright: Copyright 2020, James Ashmore
# Email: jma1991@icloud.com
# License: MIT

main <- function(input, output, params, log) {

    # Log

    out <- file(log$out, open = "wt")

    err <- file(log$err, open = "wt")

    sink(out, type = "output")

    sink(err, type = "message")

	# Script function

	library(ggplot2)

	library(oligo)

	x <- readRDS(input$rds)

	m <- rowMeans(exprs(x))

	df <- data.frame(mean = m)

	gg <- ggplot(df, aes(mean)) + 
		geom_histogram(bins = 100) + 
		labs(x = "Average Expression", y = "Frequency") + 
		theme_bw()

	ggsave(output$pdf, plot = gg)

}

main(snakemake@input, snakemake@output, snakemake@params, snakemake@log)
