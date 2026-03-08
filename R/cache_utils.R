#' Check if a pin exists
#' @noRd
pin_exists <- function(board, name) {
  tryCatch(
    {
      pins::pin_meta(board, name)
      TRUE
    },
    error = function(e) FALSE
  )
}

#' Read pin safely
#' @noRd
read_pin_safe <- function(board, name) {
  pins::pin_read(board, name)
}

#' Write pin safely
#' @noRd
write_pin_safe <- function(board, name, data, metadata = list()) {
  pins::pin_write(
    board,
    x = data,
    name = name,
    type = "rds",
    metadata = metadata
  )
}
