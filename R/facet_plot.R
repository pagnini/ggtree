##' plot tree associated data in an additional panel
##'
##'
##' 'facet_plot()' automatically re-arranges the input 'data' according to the tree structure,
##' visualizes the 'data' on specific 'panel' using the 'geom' function with aesthetic 'mapping' and other parameters,
##' and align the graph with the tree 'p' side by side.
##' @title facet_plot
##' @param p tree view
##' @param panel panel name for plot of input data
##' @param data data to plot by 'geom', first column should be matched with tip label of tree
##' @param geom geom function to plot the data
##' @param mapping aes mapping for 'geom'
##' @param ... additional parameters for 'geom'
##' @return ggplot object
##' @examples
##' tr <- rtree(10)
##' dd = data.frame(id=tr$tip.label, value=abs(rnorm(10)))
##' p <- ggtree(tr)
##' facet_plot(p, 'Trait', data = dd, geom=geom_point, mapping=aes(x=value))
##' @export
##' @author Guangchuang Yu
facet_plot <- function(p, panel, data, geom, mapping=NULL, ...) {
    p <- add_panel(p, panel)
    df <- p %+>% data
    p + geom(data=df, mapping=mapping, ...)
}


##' @importFrom ggplot2 facet_grid
add_panel <- function(p, panel) {
    df <- p$data
    if (is.null(df[[".panel"]])) {
        df[[".panel"]] <- factor("Tree")
    }
    levels(df$.panel) %<>% c(., panel)
    p$data <- df
    p + facet_grid(.~.panel, scales="free_x")
}


##' label facet_plot output
##'
##' 
##' @title facet_labeller
##' @param p facet_plot output
##' @param label labels of facet panels
##' @return ggplot object
##' @importFrom ggplot2 labeller
##' @export
##' @author Guangchuang Yu
facet_labeller <- function(p, label) {
    ## .panel <- panel_col_var(p)
    ## lbs <- panel_col_levels(p)
    lbs  <-  levels(p$data$.panel)
    names(lbs)  <-  lbs
    label <- label[names(label) %in% lbs]
    lbs[names(label)]  <-  label

    ## ff <- as.formula(paste(" . ~ ", .panel))
    p + facet_grid(. ~ .panel, scales="free_x",
                   labeller = labeller(.panel = lbs))
}


##' set relative widths (for column only) of facet plots
##'
##' 
##' @title facet_widths
##' @param p ggplot or ggtree object
##' @param widths relative widths of facet panels
##' @return ggplot object by redrawing the figure (not a modified version of input object)
##' @author Guangchuang Yu
##' @export
##' @importFrom ggplot2 ggplot_gtable
facet_widths <- function(p, widths) {
    if (!is.null(names(widths))) {
        ## if (is.ggtree(p) && !is.null(names(widths))) {
        ## .panel <- levels(p$data$.panel)
        .panel <- panel_col_levels(p)
        w <- rep(1, length=length(.panel))
        names(w) <- .panel
        w[names(widths)] <- widths
        widths <- w
    }
    gt  <- ggplot_gtable(ggplot_build(p))
    for(i in seq_along(widths)) {
        j <- gt$layout$l[grep(paste0('panel-', i), gt$layout$name)]
        gt$widths[j] = widths[i] * gt$widths[j]
    }
    return(ggplotify::as.ggplot(gt))
}

panel_col_var <- function(p) {
    m <- p$facet$params$cols[[1]]
    if (is.null(m))
        return(m)

    ## rlang::quo_name(m)
    rlang::quo_text(m)
}

panel_col_levels <- function(p) {
    levels(p$data[[panel_col_var(p)]])
}
