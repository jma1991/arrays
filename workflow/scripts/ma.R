# Author: James Ashmore
# Copyright: Copyright 2020, James Ashmore
# Email: james.ashmore@zifornd.com
# License: MIT

plotMA <- function(object, ...) {

    UseMethod("plotMA")

}

plotMA.ExpressionSet <- function(object, col) {
    
    mat <- exprs(object)
    
    med <- apply(mat, 1, median, na.rm = TRUE)
    
    M <- mat - med
    
    A <- (mat + med) / 2
    
    df <- data.frame(
        M = as.vector(M), 
        A = as.vector(A), 
        I = colnames(mat)[col(mat)], 
        group = pData(object)[, col][col(mat)]
    )

    g <- ggplot(df, aes(A, M, colour = group)) + geom_point(size = 0.05) + facet_wrap_paginate(~ I, ncol = 4, nrow = 4)

    g

}

main <- function(input, output, params, log) {

    # Log

    out <- file(log$out, open = "wt")

    err <- file(log$err, open = "wt")

    sink(out, type = "output")

    sink(err, type = "message")

    # Script

    library(ggforce)

    library(oligo)

    obj <- readRDS(input$rds)

    plt <- plotMA(obj, col = params$col)
        
    num <- n_pages(plt)

    itr <- seq_len(num)

    png(output$png)
    
    for (i in itr) {
        
        print(plt + facet_wrap_paginate(~ I, ncol = 4, nrow = 4, page = i))
    
    }

    dev.off()

}

main(snakemake@input, snakemake@output, snakemake@params, snakemake@log)