#' ChrisDoc PDF (bookdown::pdf_document2 wrapper)
#'
#' Use in YAML as:
#'   output:
#'     chrisdoc::pdf_chrisdoc
#'
#' @param number_sections Logical; default FALSE (matches your current choice).
#' @param latex_engine Engine; default "xelatex".
#' @param keep_tex Logical; keep intermediate .tex; default TRUE.
#' @param includes Optional rmarkdown::includes() to add *extra* includes.
#'        The chrisdoc preamble is always injected in_header first.
#' @param ... Passed through to bookdown::pdf_document2().
#' @return An rmarkdown output format.
#' @export
pdf_chrisdoc <- function(number_sections = FALSE,
                         latex_engine = "xelatex",
                         keep_tex = TRUE,
                         includes = NULL,
                         ...) {

  if (!requireNamespace("bookdown", quietly = TRUE)) {
    stop("Install bookdown first.")
  }

  # locate preamble + fonts
  preamble <- system.file("rmarkdown", "resources", "chrisdoc_preamble.tex",
                          package = "chrisdoc")

  font_dir <- normalizePath(
    system.file("fonts", package = "chrisdoc"),
    winslash = "/", mustWork = FALSE
  )

  # write \chrisdocfontpath macro
  font_macro <- tempfile(fileext = ".tex")
  if (file.exists(file.path(font_dir, "SourceSans3-Regular.ttf"))) {
    writeLines(sprintf("\\newcommand{\\chrisdocfontpath}{%s/}", font_dir), font_macro)
  } else {
    writeLines("% chrisdoc fonts not found", font_macro)
  }

  # Build header includes
  if (is.null(includes)) {
    includes <- rmarkdown::includes(in_header = c(font_macro, preamble))
  } else {
    includes$in_header <- c(font_macro, preamble, includes$in_header)
  }

  # now call pdf_document2 and let it handle injection ordering
  bookdown::pdf_document2(
    number_sections = number_sections,
    latex_engine    = latex_engine,
    keep_tex        = keep_tex,
    includes        = includes,
    ...
  )
}
