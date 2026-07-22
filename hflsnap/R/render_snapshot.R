#' Render an HFL Empirical Snapshot: PDF + WordPress companion
#'
#' Knits an Empirical Snapshot \code{.Rmd} to PDF using \code{snapshots.tex},
#' then produces a body-only WordPress companion HTML file from the same
#' knitted Markdown -- no second knit, so R chunks execute exactly once.
#'
#' Requires \code{snapshots.tex} (and, if the document has a figure or bundled
#' fonts, \code{fonts/}) to already be present in the project folder --
#' \code{\link{hfl_use}} puts them there.
#'
#' @param input Path to the Snapshot \code{.Rmd} file.
#' @param bibliography Optional path to a \code{.bib} file to pass to the
#'   HTML pandoc pass via \code{--citeproc}. Only needed if the PDF pass
#'   itself does not already resolve citations into the knitted Markdown.
#' @param quiet Logical. Suppress rmarkdown/pandoc console output.
#'
#' @return Invisibly, a named character vector with elements \code{pdf} and
#'   \code{html} giving the paths written (\code{html} is \code{NA} if no
#'   knitted Markdown was found).
#' @export
#'
#' @examples
#' \dontrun{
#' render_snapshot("snapshot.Rmd")
#' }
render_snapshot <- function(input,
                             bibliography = NULL,
                             quiet        = FALSE) {

  stopifnot(file.exists(input))
  if (!requireNamespace("rmarkdown", quietly = TRUE))
    stop("rmarkdown is required.")
  if (!file.exists("snapshots.tex"))
    stop("snapshots.tex not found in the working directory. Run hfl_use() first.")

  base <- tools::file_path_sans_ext(basename(input))

  # --- 1. PDF (knitr runs the chunks; snapshots.tex does the layout) -------
  pdf_out <- rmarkdown::render(
    input         = input,
    output_format = "all",
    quiet         = quiet
  )

  # --- 2. WordPress companion, from the knitted markdown -------------------
  # keep_md: true in the YAML leaves <base>.knit.md behind: chunks already
  # executed, inline R already substituted. That is the correct HTML source --
  # rendering the .Rmd again would re-run every chunk.
  knit_md <- paste0(base, ".knit.md")
  if (!file.exists(knit_md)) knit_md <- paste0(base, ".md")

  if (file.exists(knit_md)) {
    html_out <- paste0(base, "-wordpress.html")
    options <- "--no-highlight"
    if (!is.null(bibliography) && file.exists(bibliography)) {
      options <- c(options, "--citeproc", paste0("--bibliography=", bibliography))
    }
    rmarkdown::pandoc_convert(
      input   = knit_md,
      to      = "html",
      output  = html_out,
      options = options,
      verbose = !quiet
    )
    if (!quiet) message("WordPress companion: ", html_out)
  } else {
    warning(
      "No knitted markdown found (set `keep_md: true` in the YAML), ",
      "so the WordPress companion was not written."
    )
    html_out <- NA_character_
  }

  invisible(c(pdf = pdf_out, html = html_out))
}
