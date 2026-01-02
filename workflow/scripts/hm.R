# Author: James Ashmore
# Copyright: Copyright 2020, James Ashmore
# Email: jma1991@icloud.com
# License: MIT

heatmap <- function(object) {

    UseMethod("heatmap")

}

heatmap.ExpressionSet <- function(object) {

    require(RColorBrewer)

    expr <- exprs(object)

    dist <- dist(t(expr))

    brew <- RColorBrewer::brewer.pal(5, "Reds")
    
    cols <- colorRampPalette(rev(brew))(255)

    anno <- data.frame(
        Condition = object$condition,
        row.names = colnames(object)
    )

    pheatmap(
        mat = as.matrix(dist),
        color = cols,
        clustering_distance_rows = dist,
        clustering_distance_cols = dist,
        treeheight_row = 0,
        annotation_row = anno,
        show_colnames = FALSE,
        silent = TRUE
    )

}

main <- function(input, output, params, log) {

    # Log

    out <- file(log$out, open = "wt")

    err <- file(log$err, open = "wt")

    sink(out, type = "output")

    sink(err, type = "message")

    # Script

    library(oligo)

    library(pheatmap)

    x <- readRDS(input$rds)

    p <- heatmap(x)

    pdf(output$pdf)

    grid::grid.newpage()

    grid::grid.draw(p$gtable)

    dev.off()

}

main(snakemake@input, snakemake@output, snakemake@params, snakemake@log)