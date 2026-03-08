# Internal helper functions for derive_measure()
# Not exported
# Internal helper functions for derive_measure
# Not exported

.measure_helpers <- rlang::env()

.measure_helpers$yoy <- function(x, lag_period = 12) {
  (x - dplyr::lag(x, lag_period)) / dplyr::lag(x, lag_period) * 100
}

.measure_helpers$mom <- function(x, lag_period = 1) {
  (x - dplyr::lag(x, lag_period)) / dplyr::lag(x, lag_period) * 100
}

.measure_helpers$qoq <- function(x, lag_period = 3) {
  (x - dplyr::lag(x, lag_period)) / dplyr::lag(x, lag_period) * 100
}

.measure_helpers$rebased <- function(x, base = 100) {
  x / x[1] * base
}

.measure_helpers$pct_change <- function(x, lag_period = 1) {
  (x - dplyr::lag(x, lag_period)) / dplyr::lag(x, lag_period) * 100
}
