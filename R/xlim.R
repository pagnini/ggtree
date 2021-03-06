##' set x axis limits for Tree panel
##'
##'
##' @title xlim_tree
##' @param xlim xlim
##' @return updated tree view
##' @export
##' @author guangchuang yu
xlim_tree <- function(xlim) {
    xlim_expand(xlim, panel='Tree')
}


##' expand x axis limits for specific panel
##'
##'
##' @title xlim_expand
##' @param xlim xlim
##' @param panel panel
##' @return updated tree view
##' @importFrom ggplot2 geom_blank
##' @export
##' @author guangchuang yu
xlim_expand <- function(xlim, panel) {
    dummy <- data.frame(x=xlim, .panel=panel)
    ly <- geom_blank(aes_(x=~x), dummy, inherit.aes = FALSE)
    class(ly) <- c("facet_xlim", class(ly))
    return(ly)
}

##' @importFrom rlang quo_name
##' @importFrom magrittr extract
##' @importFrom ggplot2 ggplot_add
##' @method ggplot_add facet_xlim
##' @export
ggplot_add.facet_xlim <- function(object, plot, object_name) {
    var <- panel_col_var(plot)
    free_x <- plot$facet$params$free$x
    if (!is.null(free_x)) {
        if (!free_x)
            message('If you want to adjust xlim for specific panel, ',
                    'you need to set `scales = "free_x"`')
    }

    class(object) %<>% extract(., .!= "facet_xlim")

    if (!is.null(var)) {
        nm <- names(object$data)
        nm[nm == '.panel']  <- var
        names(object$data)  <- nm
    }

    ggplot_add(object, plot, object_name)
}

##' reverse timescle x-axis
##'
##'
##' @title revts
##' @param treeview treeview
##' @return updated treeview
##' @export
##' @author guangchuang yu
revts <- function(treeview) {
    x <- treeview$data$x
    mx <- max(x)
    treeview$data$x <- x - mx
    treeview$data$branch <- treeview$data$branch - mx
    treeview
}
