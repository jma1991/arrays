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

	library(oligo)

	library(
		params$platform,
		character.only = TRUE,
		lib.loc = "resources/bioconductor/platform/lib/R/library"
	)

	dat <- read.delim(input$tsv, row.names = "sample")

	set <- read.celfiles(
		filenames = dat$filename, 
		phenoData = AnnotatedDataFrame(dat)
	)

	saveRDS(set, file = output$rds)

}

main(snakemake@input, snakemake@output, snakemake@params, snakemake@log)