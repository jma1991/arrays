# Author: James Ashmore
# Copyright: Copyright 2020, James Ashmore
# Email: james.ashmore@zifornd.com
# License: MIT

.libPaths(new = "resources/bioconductor/platform/lib/R/library")

main <- function(input, output, params, log) {

    # Log

    out <- file(log$out, open = "wt")

    err <- file(log$err, open = "wt")

    sink(out, type = "output")

    sink(err, type = "message")

    # Script

	library(oligo)

	library(params$platform, character.only = TRUE)

	obj <- readRDS(input$rds)

	ids <- sampleNames(obj)

	itr <- seq_along(ids)

	png(output$png)

	for (i in itr) {
		
		image(obj, which = i, main = ids[i])

	}

	dev.off()

}

main(snakemake@input, snakemake@output, snakemake@params, snakemake@log)