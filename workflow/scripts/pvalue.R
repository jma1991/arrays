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

    # Script

    library(ggplot2)
	
	res <- read.delim(input$tsv)
	
	plt <- ggplot(res, aes(x = P.Value)) + 
		geom_histogram(binwidth = 0.05, colour = "black", fill = "gainsboro", boundary = 0) + 
		labs(x = expression(italic(p)*"-values"), y = "Frequency") + 
        theme_bw()

	ggsave(output$pdf, plot = plt)

}

main(snakemake@input, snakemake@output, snakemake@params, snakemake@log)