# Author: James Ashmore
# Copyright: Copyright 2020, James Ashmore
# Email: james.ashmore@zifornd.com
# License: MIT

add.status <- function(x, PAdj = 0.05) {

    # Determine the status of each gene in the results table

    x$status <- factor("NS", levels = c("Up", "NS", "Down"))

    x$status[x$logFC > 0 & x$adj.P.Val < PAdj] <- "Up"

    x$status[x$logFC < 0 & x$adj.P.Val < PAdj] <- "Down"

    return(x)

}

add.symbol <- function(x, n = 50) {

    # Show symbol for the top N genes in the results table

    i <- sort(x$adj.P.Val, decreasing = FALSE, index.return = TRUE)$ix[seq_len(n)]

    x$symbol <- ""

    x$symbol[i] <- x$SYMBOL[i]

    return(x)

}

main <- function(input, output, params, log) {

    # Log function

    out <- file(log$out, open = "wt")

    err <- file(log$err, open = "wt")

    sink(out, type = "output")

    sink(err, type = "message")

    # Script function

    library(ggplot2)

    library(ggrepel)

    library(scales)

    res <- read.delim(input$tsv)

    res <- add.status(res, PAdj = params$PAdj)

    res <- add.symbol(res, n = params$n)

    res <- res[order(res$adj.P.Val, decreasing = TRUE), ]

    col <- c("Up" = "#d8b365", "NS" = "#f5f5f5", "Down" = "#5ab4ac")

    lab <- c(
        "Up"   = sprintf("Up (%s)", comma(sum(res$status == "Up"))),
        "NS"   = sprintf("NS (%s)", comma(sum(res$status == "NS"))),
        "Down" = sprintf("Down (%s)", comma(sum(res$status == "Down")))
    )
    
    plt <- ggplot(res, aes(logFC, -log10(P.Value), colour = status, label = symbol)) + 
        geom_point() + 
        scale_colour_manual(values = col, labels = lab) +
        geom_text_repel(size = 1.88, colour = "#000000", show.legend = FALSE, max.overlaps = Inf) +
        labs(
            x = expression("Log"[2]*"(fold change)"),
            y = expression("-Log"[10]*"("*italic(p)*"-value)"),
            colour = "Status"
        ) + 
        theme_bw() + 
        theme(
            aspect.ratio = 1,
            axis.title.x = element_text(margin = unit(c(1, 0, 0, 0), "lines")),
            axis.title.y = element_text(margin = unit(c(0, 1, 0, 0), "lines"))
        )

    ggsave(output$pdf, plot = plt)

}

main(snakemake@input, snakemake@output, snakemake@params, snakemake@log)
