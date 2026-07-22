\name{hfl_use}
\alias{hfl_use}
\title{Scaffold a new HFL Empirical Snapshot project}
\usage{
hfl_use(path = ".", include_template = TRUE,
        template_name = "snapshot.Rmd", overwrite = FALSE)
}
\arguments{
\item{path}{Destination directory. Defaults to the current working directory.}

\item{include_template}{Logical. If \code{TRUE} (the default), also copy
\code{snapshot-template.Rmd} as \code{snapshot.Rmd} (or under
\code{template_name} if given) as a starting point for a new document.}

\item{template_name}{File name to give the copied starter \code{.Rmd}.
Defaults to \code{"snapshot.Rmd"}.}

\item{overwrite}{Logical. If \code{FALSE} (the default), existing files at
the destination are left untouched and reported, not overwritten.}
}
\value{
Invisibly, a character vector of the paths written.
}
\description{
Copies the support files an Empirical Snapshot needs -- the LaTeX template,
bundled fonts, the citation style, and (optionally) a starter \code{.Rmd} --
into the current working directory. Run this once per new Snapshot
project, before you start writing.
}
\details{
This does not install a custom rmarkdown output format. It only places
plain files (\code{snapshots.tex}, \code{fonts/}, \code{default.csl},
\code{snapshot-template.Rmd}) next to your project so
\code{rmarkdown::pdf_document} can find them. A collaborator who receives
your project folder can knit it with plain rmarkdown -- they do not need
\code{hflsnap} installed, only the files it copied.
}
\examples{
\dontrun{
dir.create("my-snapshot")
setwd("my-snapshot")
hfl_use()
}
}
