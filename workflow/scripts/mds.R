# Author: James Ashmore
# Copyright: Copyright 2020, James Ashmore
# Email: james.ashmore@zifornd.com
# License: MIT

plotMDS <- function(object, ...) {

    UseMethod("plotMDS")

}

plotMDS.ExpressionSet <- function(object, col) {

    mat <- exprs(object)
    
    var <- matrixStats::rowVars(mat)

    num <- min(500, length(var))
    
    ind <- order(var, decreasing = TRUE)[seq_len(num)]
    
    dst <- dist(t(mat[ind, ]))
    
    mds <- cmdscale(as.matrix(dst))

    dat <- data.frame(
        MD1 = mds[, 1], 
        MD2 = mds[, 2], 
        group = pData(object)[, col]
    )

    ggplot(dat, aes(MD1, MD2, colour = group)) + 
        geom_point(size = 3) + 
        labs(x = "MDS 1", y = "MDS 2", colour = "Group")

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

    obj <- readRDS(input$rds)

    plt <- plotMDS(obj, col = params$col)
    
    ggsave(output$pdf, plot = plt)

}

main(snakemake@input, snakemake@output, snakemake@params, snakemake@log)