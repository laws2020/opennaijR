#-----------------
# Cache Clear
#-----------------
#' Clear opennaijR cache
#'
#' @param dataset Character scalar. Dataset name (e.g., "fx_reserves").
#' @param all Logical. If TRUE, clears the entire cache.
#'
#' @return Invisibly TRUE if successful, FALSE otherwise.
#' @export
#' @examples
#' \dontrun{
#' naijr_cache_clear("fx_reserves")
#' naijr_cache_clear(all = TRUE)
#' }
naijr_cache_clear <- function(dataset = NULL, all = FALSE) {
  board <- get_opennaijR_board()
  pins  <- pins::pin_list(board)

  if (all) {
    for (p in pins) pins::pin_delete(board, p)
    message("opennaijR cache cleared completely.")
    return(invisible(TRUE))
  }

  if (is.null(dataset)) {
    stop("Please provide `dataset` or set `all = TRUE`.", call. = FALSE)
  }

  prefix <- paste0("cbn__", dataset, "__")
  targets <- grep(paste0("^", prefix), pins, value = TRUE)

  if (!length(targets)) {
    message("No cached entries found for dataset: ", dataset)
    return(invisible(FALSE))
  }

  for (p in targets) pins::pin_delete(board, p)

  message(
    sprintf(
      "Cleared %d cached entr%s for '%s'.",
      length(targets),
      ifelse(length(targets) == 1, "y", "ies"),
      dataset
    )
  )

  invisible(TRUE)
}
