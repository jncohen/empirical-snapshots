#' Scaffold a new HFL Empirical Snapshot project
#'
#' Copies the support files an Empirical Snapshot needs -- the LaTeX
#' template, bundled fonts, the citation style, and (optionally) a starter
#' \code{.Rmd} -- into the current working directory. Run this once per new
#' Snapshot project, before you start writing.
#'
#' This does not install a custom rmarkdown output format. It only places
#' plain files (\code{snapshots.tex}, \code{fonts/}, \code{default.csl},
#' \code{snapshot-template.Rmd}) next to your project so
#' \code{rmarkdown::pdf_document} can find them. A collaborator who receives
#' your project folder can knit it with plain rmarkdown -- they do not need
#' \code{hflsnap} installed, only the files it copied.
#'
#' @param path Destination directory. Defaults to the current working
#'   directory.
#' @param include_template Logical. If \code{TRUE} (the default), also copy
#'   \code{snapshot-template.Rmd} as \code{snapshot.Rmd} (or under
#'   \code{template_name} if given) as a starting point for a new document.
#' @param template_name File name to give the copied starter \code{.Rmd}.
#'   Defaults to \code{"snapshot.Rmd"}.
#' @param overwrite Logical. If \code{FALSE} (the default), existing files
#'   at the destination are left untouched and reported, not overwritten.
#'
#' @return Invisibly, a character vector of the paths written.
#' @export
#'
#' @examples
#' \dontrun{
#' dir.create("my-snapshot")
#' setwd("my-snapshot")
#' hfl_use()
#' }
hfl_use <- function(path = ".",
                     include_template = TRUE,
                     template_name = "snapshot.Rmd",
                     overwrite = FALSE) {

  if (!dir.exists(path)) stop("Destination directory does not exist: ", path)

  extdata <- system.file("extdata", package = "hflsnap")
  if (extdata == "") stop("Could not locate hflsnap's installed support files.")

  written <- character(0)
  skipped <- character(0)

  copy_one <- function(from, to) {
    if (file.exists(to) && !overwrite) {
      skipped <<- c(skipped, to)
      return(invisible(FALSE))
    }
    ok <- file.copy(from, to, overwrite = overwrite)
    if (ok) written <<- c(written, to)
    invisible(ok)
  }

  # snapshots.tex
  copy_one(file.path(extdata, "snapshots.tex"), file.path(path, "snapshots.tex"))

  # default.csl
  copy_one(file.path(extdata, "default.csl"), file.path(path, "default.csl"))

  # fonts/
  fonts_dest <- file.path(path, "fonts")
  if (!dir.exists(fonts_dest)) dir.create(fonts_dest)
  font_files <- list.files(file.path(extdata, "fonts"), full.names = TRUE)
  for (f in font_files) {
    copy_one(f, file.path(fonts_dest, basename(f)))
  }

  # starter .Rmd
  if (include_template) {
    copy_one(
      file.path(extdata, "snapshot-template.Rmd"),
      file.path(path, template_name)
    )
  }

  if (length(written)) {
    message("hfl_use(): wrote ", length(written), " file(s) to ", normalizePath(path))
  }
  if (length(skipped)) {
    message(
      "hfl_use(): left ", length(skipped), " existing file(s) untouched ",
      "(pass overwrite = TRUE to replace): ", paste(basename(skipped), collapse = ", ")
    )
  }

  invisible(written)
}
