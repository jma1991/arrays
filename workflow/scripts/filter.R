# Author: James Ashmore
# Copyright: Copyright 2020, James Ashmore
# Email: james.ashmore@zifornd.com
# License: MIT

filterByType <- function(object) {

	# Filter control probes

	data <- fData(object)

	ctrl <- "ControlType" %in% colnames(data)

	if (ctrl) {

		keep <- data$ControlType == 0L

	} else {

		keep <- rep(TRUE, times = nrow(data))

	}

	object <- object[keep, ]

}

filterByUniq <- function(object) {

	# Filter non-unique probes
	
	data <- fData(object)
	
	all.equal <- function(x) length(unique(x)) == 1L

	keep <- data.frame(
		ENTREZID = sapply(data$ENTREZID, all.equal),
		SYMBOL   = sapply(data$ENTREZID, all.equal),
		GENENAME = sapply(data$GENENAME, all.equal)
	)
	
	keep <- apply(keep, 1, all)
	
	object <- object[keep, ]

	# Unlist feature columns
	
	data <- fData(object)

	data <- data.frame(
		PROBEID   = data$PROBEID,
		ENTREZID  = unlist(data$ENTREZID),
		SYMBOL    = unlist(data$SYMBOL),
		GENENAME  = unlist(data$GENENAME),
		row.names = data$PROBEID
	)

	fData(object) <- data
	
	# Filter missing probes

	data <- fData(object)

	not.na <- function(x) !is.na(x)
	
	keep <- sapply(data$SYMBOL, not.na)
	
	object <- object[keep, ]
	
}

filterByExpr <- function(object, group = NULL, exprs = NULL) {

	# Filter unexpressed probes

	y <- exprs(object)

	group <- as.factor(pData(object)[, group])
	
	n <- tabulate(group)
	
	size <- min(n[n > 0L])

	keep <- rowSums(y >= exprs) >= size

	object <- object[keep, ]

}

main <- function(input, output, params, log) {

    # Log

    out <- file(log$out, open = "wt")

    err <- file(log$err, open = "wt")

    sink(out, type = "output")

    sink(err, type = "message")

	# Script

	library(oligo)

	x <- readRDS(input$rds)

	x <- filterByType(x)

	x <- filterByUniq(x)

	x <- filterByExpr(x, group = params$group, exprs = params$exprs)

	saveRDS(x, file = output$rds)

}

main(snakemake@input, snakemake@output, snakemake@params, snakemake@log)