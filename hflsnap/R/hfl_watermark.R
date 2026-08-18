#' Register the bundled HFL mono face for use in figures
#'
#' Registers Spline Sans Mono (shipped in \code{inst/extdata/fonts}) with
#' \pkg{systemfonts} under a stable family name, so figures can call it by
#' name. Safe to call repeatedly -- registration is skipped if the family is
#' already present.
#'
#' Font registration only affects devices that consult the \pkg{systemfonts}
#' registry. That means \code{ragg::agg_png()} (or \code{ggplot2::ggsave()}
#' with \code{device = ragg::agg_png}). The base \code{grDevices::png()}
#' device will silently fall back to a default face.
#'
#' @param name Family name to register under. Defaults to \code{"HFL Mono"}.
#'
#' @return The registered family name, or \code{""} if registration was not
#'   possible (in which case the caller should let the device pick a default).
#' @export
hfl_font_mono <- function(name = "HFL Mono") {

  if (!requireNamespace("systemfonts", quietly = TRUE)) {
    warning("Package 'systemfonts' is not installed, so the HFL mono face ",
            "cannot be registered. The figure watermark will render in the ",
            "device's default font. Install systemfonts (and save with ",
            "ragg::agg_png) for on-brand typography.", call. = FALSE)
    return("")
  }

  already <- tryCatch(
    name %in% systemfonts::registry_fonts()$family,
    error = function(e) FALSE
  )
  if (isTRUE(already)) return(name)

  font_dir <- system.file("extdata", "fonts", package = "hflsnap")
  files <- c(
    plain = file.path(font_dir, "SplineSansMono-Regular.ttf"),
    bold  = file.path(font_dir, "SplineSansMono-SemiBold.ttf")
  )

  if (!nzchar(font_dir) || !all(file.exists(files))) {
    warning("Bundled Spline Sans Mono files were not found in hflsnap. ",
            "The figure watermark will render in the device's default font.",
            call. = FALSE)
    return("")
  }

  ok <- tryCatch({
    systemfonts::register_font(
      name  = name,
      plain = files[["plain"]],
      bold  = files[["bold"]]
    )
    TRUE
  }, error = function(e) FALSE)

  if (!ok) {
    warning("Registering the HFL mono face failed. The figure watermark ",
            "will render in the device's default font.", call. = FALSE)
    return("")
  }

  name
}


#' Add the HFL attribution footer to a figure
#'
#' Appends a two-line attribution footer to the bottom of a \pkg{ggplot2}
#' figure, in a fixed position, so that a figure lifted out of the Snapshot
#' PDF or off the website still carries its source.
#'
#' Placement is deliberately anchored to the \emph{plot} region rather than
#' the panel (\code{plot.caption.position = "plot"}). This is what makes the
#' footer land in the same place on every figure: panel-anchored captions
#' shift horizontally depending on how wide the y-axis labels happen to be,
#' whereas plot-anchored ones are flush to the image edge regardless of the
#' chart's content.
#'
#' The footer deliberately carries no license string. The document's license
#' is set once in the \code{snapshot_license} YAML field and rendered in the
#' sheet footer; repeating it in the image invites the two drifting apart.
#'
#' The footer carries no font of its own. See \code{family} below: the HFL
#' mono face is applied by \code{\link{hfl_save_figure}} at save time, so
#' that previewing or knitting a chunk on an ordinary device cannot fail.
#'
#' Add it after any complete theme (\code{theme_minimal()} and friends): a
#' complete theme applied afterwards resets \code{plot.caption.position}
#' back to the panel and the footer stops being consistently placed.
#'
#' Use it as an ordinary ggplot layer: \code{p + hfl_watermark()}. Because
#' this sets \code{labs(caption =)}, it replaces any caption already on the
#' plot -- which is intended, since the Snapshot format expects figure
#' labelling to live in \code{snapshot_feature_caption}, not in the image.
#'
#' @param data_note Second line. Defaults to the SCF source line; change it
#'   for any Snapshot built on another dataset.
#' @param org First line. Defaults to \code{"Household Finance Lab"}.
#' @param size Text size in points. Default \code{6.5}.
#' @param colour Text colour. Defaults to \code{"#56544B"}, the sheet's
#'   footer grey.
#' @param uppercase Logical. Render in caps, per HFL's label convention.
#' @param family Font family. Defaults to \code{""} -- the device's own
#'   default. This is deliberate: a family registered with \pkg{systemfonts}
#'   is unknown to the \code{pdf()} device knitr uses when drawing a chunk,
#'   and asking for it there fails with "invalid font type". The HFL face is
#'   applied instead at save time by \code{\link{hfl_save_figure}}, which
#'   controls the device. Pass a family explicitly only if you are rendering
#'   through \pkg{ragg} yourself.
#' @param margin_top Space between the plot and the footer, in points.
#'
#' @return A list of \pkg{ggplot2} components, addable with \code{+}.
#' @export
#'
#' @examples
#' \dontrun{
#' library(ggplot2)
#' p <- ggplot(mtcars, aes(wt, mpg)) + geom_point()
#' p + hfl_watermark()
#'
#' # Another dataset:
#' p + hfl_watermark(data_note = "Data: American Community Survey")
#'
#' # Save so the registered font is honoured:
#' ggsave("figures/fig1.png", p + hfl_watermark(),
#'        width = 5, height = 3.4, dpi = 300, device = ragg::agg_png)
#' }
hfl_watermark <- function(data_note = "Data: Survey of Consumer Finances",
                          org       = "Household Finance Lab",
                          size      = 6.5,
                          colour    = "#56544B",
                          uppercase = TRUE,
                          family    = NULL,
                          margin_top = 6) {

  if (!requireNamespace("ggplot2", quietly = TRUE))
    stop("Package 'ggplot2' is required for hfl_watermark().", call. = FALSE)

  # NB: deliberately NOT hfl_font_mono() here -- see @param family.
  if (is.null(family)) family <- ""

  lines <- c(org, data_note)
  lines <- lines[!is.na(lines) & nzchar(lines)]
  if (!length(lines))
    stop("hfl_watermark() needs at least one of 'org' or 'data_note'.",
         call. = FALSE)
  if (isTRUE(uppercase)) lines <- toupper(lines)

  list(
    ggplot2::labs(caption = paste(lines, collapse = "\n")),
    ggplot2::theme(
      plot.caption.position = "plot",
      plot.caption = ggplot2::element_text(
        family     = family,
        size       = size,
        colour     = colour,
        hjust      = 0,
        vjust      = 1,
        lineheight = 1.3,
        margin     = ggplot2::margin(t = margin_top, unit = "pt")
      )
    )
  )
}
