#' Fill Missing Values in Datasets
#'
#' @description
#' Provides multiple methods to impute missing values (NAs) in Nigerian datasets,
#' supporting KNN, Linear Interpolation, and LOCF.
#'
#' @param data A data frame or tibble.
#' @param method Character. The imputation method: "knn", "linear", or "locf".
#' Defaults to "locf" (best for time-series).
#' @param k Integer. Number of neighbors to use if method is "knn". Defaults to 5.
#' @param cols Character vector. Specific columns to fill. If NULL, applies to all numeric columns.
#'
#' @return A data frame with missing values filled.
#'
#' @export
ng_fill_missing <- function(data, method = c("locf", "knn", "linear"), k = 5, cols = NULL) {

  method <- match.arg(method)
  df <- data

  # Identify columns to process
  if (is.null(cols)) {
    cols <- names(df)[sapply(df, is.numeric)]
  }

  if (method == "locf") {
    # Last Observation Carried Forward (standard for inflation/rates)
    df <- df |> tidyr::fill(dplyr::all_of(cols), .direction = "down")

  } else if (method == "linear") {
    # Linear Interpolation (draws a straight line between points)
    for (col in cols) {
      df[[col]] <- zoo::na.approx(df[[col]], na.rm = FALSE)
    }

  } else if (method == "knn") {
    # K-Nearest Neighbors (requires 'VIM' package)
    if (!requireNamespace("VIM", quietly = TRUE)) {
      stop("Package 'VIM' is required for KNN. Install it with install.packages('VIM')")
    }
    # VIM::kNN returns a data frame with extra logical columns; we strip them
    res <- VIM::kNN(df, variable = cols, k = k, imp_var = FALSE)
    df <- res
  }

  return(df)
}
