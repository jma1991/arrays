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

	library(limma)

	object <- readRDS(input$rds)

	condition <- factor(object$condition)

	batch <- factor(object$batch)

	design <- model.matrix(~ 0 + condition)

	if (nlevels(batch) > 1) {
		
		corrected <- removeBatchEffect(x = exprs(object), batch = batch, design = design)

		exprs(object) <- corrected

	}

	saveRDS(object, file = output$rds)

}

main(snakemake@input, snakemake@output, snakemake@params, snakemake@log)