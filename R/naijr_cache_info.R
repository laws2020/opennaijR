#-----------------
# Cache Info
#-----------------
#' Inspect metadata for a cached dataset
#'
#' @description
#' Retrieves metadata (e.g., creation time, size) for a cached dataset.
#'
#' @param name Character scalar. Name of the cached dataset (as returned by
#'   \code{naijr_cache_list()})
#'
#' @return A list containing metadata for the dataset.
#' @export
#' @examples
#' \dontrun{
#' pins <- naijr_cache_list()
#' naijr_cache_info(pins[1])
#' }
naijr_cache_info <- function(name) {
  stopifnot(is.character(name), length(name) == 1)

  board <- get_opennaijR_board()
  pins  <- pins::pin_list(board)

  if (!name %in% pins) {
    stop("No cached entry found for dataset: ", name, call. = FALSE)
  }

  pins::pin_meta(board, name)
}
