#-----------------
# Cache List
#-----------------
#' List cached opennaijR datasets
#'
#' @description
#' Lists all datasets currently cached by opennaijR.
#'
#' @return Character vector of cached pin names.
#' @export
#' @examples
#' \dontrun{
#' naijr_cache_list()
#' }
naijr_cache_list <- function() {
  board <- get_opennaijR_board()
  pins::pin_list(board)
}
