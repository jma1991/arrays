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

	library(oligo)

	library(
		params$organism,
		character.only  = TRUE,
		lib.loc = "resources/bioconductor/organism/lib/R/library"
	)

	library(
		params$annotation,
		character.only = TRUE,
		lib.loc = "resources/bioconductor/annotation/lib/R/library"
	)

	obj <- readRDS(input$rds)

	pkg <- eval(parse(text = params$annotation))

	ids <- featureNames(obj)

	ann <- data.frame(
		PROBEID   = ids,
		ENTREZID  = I(mapIds(pkg, keys = ids, column = "ENTREZID", keytype = "PROBEID", multiVals = "list")),
		SYMBOL    = I(mapIds(pkg, keys = ids, column = "SYMBOL",   keytype = "PROBEID", multiVals = "list")),
		GENENAME  = I(mapIds(pkg, keys = ids, column = "GENENAME", keytype = "PROBEID", multiVals = "list")),
		row.names = ids
	)

	fData(obj) <- ann

	saveRDS(obj, file = output$rds)

}

main(snakemake@input, snakemake@output, snakemake@params, snakemake@log)