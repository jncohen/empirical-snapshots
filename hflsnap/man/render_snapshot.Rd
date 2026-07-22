\name{render_snapshot}
\alias{render_snapshot}
\title{Render an HFL Empirical Snapshot: PDF + WordPress companion}
\usage{
render_snapshot(input, bibliography = NULL, quiet = FALSE)
}
\arguments{
\item{input}{Path to the Snapshot \code{.Rmd} file.}

\item{bibliography}{Optional path to a \code{.bib} file to pass to the HTML
pandoc pass via \code{--citeproc}. Only needed if the PDF pass itself does
not already resolve citations into the knitted Markdown.}

\item{quiet}{Logical. Suppress rmarkdown/pandoc console output.}
}
\value{
Invisibly, a named character vector with elements \code{pdf} and
\code{html} giving the paths written (\code{html} is \code{NA} if no
knitted Markdown was found).
}
\description{
Knits an Empirical Snapshot \code{.Rmd} to PDF using \code{snapshots.tex},
then produces a body-only WordPress companion HTML file from the same
knitted Markdown -- no second knit, so R chunks execute exactly once.
}
\details{
Requires \code{snapshots.tex} (and, if the document has a figure or
bundled fonts, \code{fonts/}) to already be present in the project folder
-- \code{\link{hfl_use}} puts them there.
}
\examples{
\dontrun{
render_snapshot("snapshot.Rmd")
}
}
