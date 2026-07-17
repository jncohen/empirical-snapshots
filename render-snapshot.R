#' Render an HFL Empirical Snapshot: PDF + WordPress companion
#'
#' Standalone. Needs only rmarkdown/knitr, pandoc, XeLaTeX, and the files in
#' this folder (snapshots.tex, fonts/, optionally snapshots.bib). No hfwgtex.
#'
#' This replaces what hfwgtex::snapshot_pdf's `wordpress: html` option used to
#' do: a LaTeX template can only make a PDF, so the website file is a second
#' pandoc pass over the same knitted markdown.
#'
#' Usage:
#'   source("render-snapshot.R")
#'   render_snapshot("0722_99netw.Rmd")
#'
#' Produces:
#'   0722_99netw.pdf                 - the one-page sheet
#'   0722_99netw-wordpress.html      - body-only HTML to paste into the Commons
#'
#' The HTML is deliberately body-only (no <head>, no CSS): the WordPress
#' synced pattern supplies the styling. Matches the shape of the companion
#' hfwgtex used to emit.

render_snapshot <- function(input,
                            bibliography = NULL,
                            quiet        = FALSE) {

  stopifnot(file.exists(input))
  if (!requireNamespace("rmarkdown", quietly = TRUE))
    stop("rmarkdown is required.")
  if (!file.exists("snapshots.tex"))
    stop("snapshots.tex not found. Run this from the snapshot project folder.")

  base <- tools::file_path_sans_ext(basename(input))

  # --- 1. PDF (knitr runs the chunks; snapshots.tex does the layout) ---------
  pdf_out <- rmarkdown::render(
    input         = input,
    output_format = "all",
    quiet         = quiet
  )

  # --- 2. WordPress companion, from the knitted markdown --------------------
  # keep_md: true in the YAML leaves <base>.knit.md behind: chunks already
  # executed, inline R already substituted. That is the correct HTML source --
  # rendering the .Rmd again would re-run every chunk.
  knit_md <- paste0(base, ".knit.md")
  if (!file.exists(knit_md)) knit_md <- paste0(base, ".md")

  if (file.exists(knit_md)) {
    html_out <- paste0(base, "-wordpress.html")
    args <- c(shQuote(knit_md), "-t", "html", "--no-highlight",
              "-o", shQuote(html_out))
    if (!is.null(bibliography) && file.exists(bibliography))
      args <- c(args, "--citeproc", "--bibliography", shQuote(bibliography))
    rmarkdown::pandoc_convert(
      input  = knit_md,
      to     = "html",
      output = html_out,
      options = c("--no-highlight",
                  if (!is.null(bibliography) && file.exists(bibliography))
                    c("--citeproc", paste0("--bibliography=", bibliography))),
      verbose = !quiet
    )
    if (!quiet) message("WordPress companion: ", html_out)
  } else {
    warning("No knitted markdown found (set `keep_md: true` in the YAML), ",
            "so the WordPress companion was not written.")
    html_out <- NA_character_
  }

  invisible(c(pdf = pdf_out, html = html_out))
}
