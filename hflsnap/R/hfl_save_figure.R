#' Save a Snapshot figure in both sheet and web variants
#'
#' Writes two PNGs from one plot: a bone-background version for the Snapshot
#' sheet, and a white-background version for WordPress and for republication.
#'
#' The two contexts want different backgrounds and neither choice serves both.
#' On the sheet (\code{#EFEDE6} bone paper) a white figure reads as a panel
#' pasted onto the page; in a white article or slide, a bone figure reads as a
#' warm rectangle. The seam is the same size either way, so the fix is not to
#' pick a side but to export twice -- it costs one call and removes the
#' judgement from the author.
#'
#' Point \code{snapshot_feature} at the sheet file; upload the web file to
#' WordPress and hand it to anyone republishing.
#'
#' Both variants are written through \code{ragg::agg_png}, which is what
#' honours the font registered by \code{\link{hfl_font_mono}}. If \pkg{ragg}
#' is not installed the files are still written, but the figure footer falls
#' back to the device's default face.
#'
#' @param plot A ggplot object, normally with \code{\link{hfl_watermark}}
#'   already added.
#' @param path Destination for the sheet (bone) variant, e.g.
#'   \code{"figures/fig1.png"}.
#' @param width,height Figure size in inches.
#' @param dpi Resolution. Default \code{300}.
#' @param web Logical. If \code{TRUE} (the default), also write the white
#'   variant.
#' @param web_suffix Inserted before the extension for the web variant.
#'   Default \code{"-web"}, giving \code{figures/fig1-web.png}.
#' @param sheet_bg,web_bg Background fills for the two variants.
#' @param panel Logical. If \code{TRUE} (the default), the panel background is
#'   set to match the plot background. Set \code{FALSE} if the chart uses a
#'   deliberately contrasting panel fill.
#'
#' @return Invisibly, a character vector of the paths written.
#' @export
#'
#' @examples
#' \dontrun{
#' fig <- ggplot(d, aes(year, value)) +
#'   geom_line() +
#'   theme_minimal(base_size = 9) +
#'   hfl_watermark()
#'
#' hfl_save_figure(fig, "figures/fig1.png", width = 4.2, height = 5.6)
#' # writes figures/fig1.png      (bone -- point snapshot_feature here)
#' #        figures/fig1-web.png  (white -- upload this to WordPress)
#' }
hfl_save_figure <- function(plot,
                            path,
                            width,
                            height,
                            dpi        = 300,
                            web        = TRUE,
                            web_suffix = "-web",
                            sheet_bg   = "#EFEDE6",
                            web_bg     = "#FFFFFF",
                            panel      = TRUE) {

  if (!requireNamespace("ggplot2", quietly = TRUE))
    stop("Package 'ggplot2' is required for hfl_save_figure().", call. = FALSE)

  have_ragg <- requireNamespace("ragg", quietly = TRUE)
  if (!have_ragg)
    warning("Package 'ragg' is not installed, so the figure will be written ",
            "with the default device and the HFL mono footer will fall back ",
            "to a default face. Install ragg for on-brand output.",
            call. = FALSE)

  ext  <- tools::file_ext(path)
  stem <- tools::file_path_sans_ext(path)
  if (!nzchar(ext)) {
    ext  <- "png"
    path <- paste0(stem, ".png")
  }

  targets <- list(list(file = path, bg = sheet_bg))
  if (isTRUE(web))
    targets[[2]] <- list(file = paste0(stem, web_suffix, ".", ext),
                         bg   = web_bg)

  written <- character(0)

  for (tg in targets) {
    dir <- dirname(tg$file)
    if (!dir.exists(dir)) dir.create(dir, recursive = TRUE)

    p <- plot + ggplot2::theme(
      plot.background = ggplot2::element_rect(fill = tg$bg, colour = NA)
    )
    # Apply the HFL mono face here rather than in hfl_watermark(): this is
    # the only point at which we know the device is ragg and can resolve a
    # systemfonts-registered family. Merges into the existing plot.caption
    # element, so size/colour/alignment set by hfl_watermark() survive.
    if (have_ragg) {
      fam <- hfl_font_mono()
      if (nzchar(fam))
        p <- p + ggplot2::theme(
          plot.caption = ggplot2::element_text(family = fam)
        )
    }
    if (isTRUE(panel))
      p <- p + ggplot2::theme(
        panel.background = ggplot2::element_rect(fill = tg$bg, colour = NA)
      )

    args <- list(filename = tg$file, plot = p, width = width,
                 height = height, dpi = dpi, bg = tg$bg)
    if (have_ragg) args$device <- ragg::agg_png

    do.call(ggplot2::ggsave, args)
    written <- c(written, tg$file)
  }

  invisible(written)
}
