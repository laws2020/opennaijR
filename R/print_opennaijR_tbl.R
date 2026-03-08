#' @export
#' @method print opennaijR_tbl
print.opennaijR_tbl <- function(x, ...) {

  cat("<opennaijR table>\n")
  cat("Rows:", nrow(x), " Columns:", ncol(x), "\n\n")

  # drop opennaijR_tbl class before printing preview
  preview <- x
  class(preview) <- setdiff(class(preview), "opennaijR_tbl")

  print(utils::head(preview, 10), ...)

  invisible(x)
}
