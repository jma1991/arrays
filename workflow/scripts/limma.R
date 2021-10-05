# Author: James Ashmore
# Copyright: Copyright 2020, James Ashmore
# Email: james.ashmore@zifornd.com
# License: MIT

makeDesign <- function(object) {

	data <- pData(object)
	
	if ("condition" %in% colnames(data)) {
		
		condition <- factor(data$condition)
	
	} else {
	
		stop("No condition")
	}

	if ("batch" %in% colnames(data)) {

		batch <- factor(data$batch)

	} else {
		
		warning("No batch")

		batch <- rep(NA, times = ncol(data))

		batch <- factor(batch)

	}

	if (nlevels(batch) < 2) {
	
		design <- model.matrix(~ 0 + condition)
	
		colnames(design) <- levels(condition)
	
	} else {
	
		design <- model.matrix(~ 0 + condition + batch)
	
		colnames(design) <- c(levels(condition), tail(levels(batch), -1))
	
	}

	design

}

main <- function(input, output, params, log, config) {

    # Log

    out <- file(log$out, open = "wt")

    err <- file(log$err, open = "wt")

    sink(out, type = "output")

    sink(err, type = "message")

    # Script

	library(limma)

	library(oligo)
	
	obj <- readRDS(input$rds)

	mod <- makeDesign(obj)
	
	fit <- lmFit(obj, mod)

	con <- sapply(config$contrasts, paste, collapse = "-")
	
	mat <- makeContrasts(contrasts = con, levels = colnames(mod))

	fit <- contrasts.fit(fit, mat)

	fit <- eBayes(fit)

	saveRDS(fit, file = output$rds)

}

main(snakemake@input, snakemake@output, snakemake@params, snakemake@log, snakemake@config)