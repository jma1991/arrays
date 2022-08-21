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

	library(
		params$organism,
		character.only = TRUE,
		lib.loc = "resources/bioconductor/organism/lib/R/library"
	)

	fit <- readRDS(input$rds)

	con <- paste(params$contrast, collapse = "-")

	out <- goana(
		de = fit, 
		coef = con, 
		geneid = "ENTREZID", 
		FDR = params$FDR,
		species = strsplit(params$organism, ".", fixed = TRUE)[[1]][2]
	)

	write.table(
		out, 
		file = output$tsv, 
		quote = FALSE, 
		sep = '\t', 
		col.names = NA
	)

}

main(snakemake@input, snakemake@output, snakemake@params, snakemake@log)
