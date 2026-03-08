#' Access Central Bank of Nigeria (CBN) datasets
#'
#' @description
#' `cbn()` provides a unified interface for retrieving datasets published by the
#' Central Bank of Nigeria (CBN). It supports dataset aliasing, variable selection,
#' date filtering, optional canonicalization, and access to raw or parsed data.
#'
#' The function follows a strict pipeline:
#' \enumerate{
#'   \item Define query intent
#'   \item Dispatch request (raw fetch only)
#'   \item Interpret payload (parse)
#'   \item Canonicalize (optional)
#' }
#'
#' @param dataset Character scalar. Name or alias of the CBN dataset to retrieve
#'   (e.g. `"inflation_ng"`, `"exchange_rate"`).
#'
#' @param variables Character vector or `NULL`. Optional subset of variables
#'   (columns) to return. If `NULL`, all available variables are returned.
#'
#' @param from,to Date or character coercible to `Date`, or `NULL`. Optional date
#'   range for time-series datasets.
#'
#' @param filters Named list. Optional key-value filters applied at the query
#'   definition stage.
#'
#' @param raw Logical. If `TRUE`, returns parsed data immediately after payload
#'   interpretation, skipping canonicalization.
#'
#' @param canonical Logical. If `TRUE` (default), applies dataset-specific
#'   canonicalization when a standardization function is defined in the manifest.
#'
#' @param refresh Logical. If `TRUE`, forces a fresh download by bypassing any
#'   cached version of the dataset. Default is `FALSE`.
#'
#' @return
#' A data frame (or tibble) containing:
#' \itemize{
#'   \item Canonicalized data if `canonical = TRUE`
#'   \item Parsed raw data if `canonical = FALSE` or `raw = TRUE`
#' }
#'
#' @details
#' Canonicalization standardizes column names, data types, and structures across
#' datasets to ensure consistency for analysis and downstream integration.
#'
#' When `raw = TRUE`, canonicalization is bypassed regardless of the value of
#' `canonical`.
#'
#' @examples
#' \dontrun{
#' cbn("inflation_ng")
#' cbn("exchange_rates", canonical = FALSE)
#' cbn("exchange_rates", raw = TRUE)
#' }
#'
#' @seealso
#' define_query(), dispatch_request(), interpret_payload(),
#' canonicalize_data()
#'
#' @export
cbn <- function(dataset,
                variables = NULL,
                from = NULL,
                to = NULL,
                filters = list(),
                raw = FALSE,
                canonical = TRUE,
                refresh = FALSE) {
  # --------------------------------
  # 1. Build intent
  # --------------------------------
  q <- define_query(
    source    = "cbn",
    dataset   = dataset,
    variables = variables,
    filters   = filters,
    from      = from,
    to        = to
  )

  # --------------------------------
  # 2. PIN CACHE CHECK (NEW)
  # --------------------------------
  board   <- get_opennaijR_board()
  hash <- digest::digest(list(
    variables = variables,
    from = from,
    to = to,
    filters = filters
  ))

  pin_key <- paste(
    q$intent$source,
    q$intent$dataset,
    hash,
    sep = "__"
  )
  if (!refresh && pin_exists(board, pin_key)) {
    message("\U0001F4E6 Loading cached CBN data from pins")

    data <- read_pin_safe(board, pin_key)

    # restore metadata (important!)
    attr(data, "source")  <- q$intent$source
    attr(data, "dataset") <- q$intent$dataset

    return(data)
  }

  # --------------------------------
  # 3. Dispatch + ingest (FETCH + PARSE)
  # --------------------------------
  q <- dispatch_request(q)
  q <- ingest_payload(q)

  if (raw) return(q$parsed_data)

  # --------------------------------
  # 4. Canonicalize
  # --------------------------------
  if (canonical && !is.null(q$manifest$standardize)) {
    message(
      sprintf(
        "Applying canonicalization using '%s'",
        q$manifest$standardize
      )
    )

    q <- canonicalize_data(q)
    data <- q$canonical_data
  } else {
    data <- q$parsed_data
  }

  # --------------------------------
  # 5. WRITE TO PINS (NEW)
  # --------------------------------
  write_pin_safe(
    board,
    pin_key,
    data,
    metadata = list(
      source     = q$intent$source,
      dataset    = q$intent$dataset,
      fetched_at = Sys.time()
    )
  )

  data
}
