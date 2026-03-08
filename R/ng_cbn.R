#' Fetch Data from the Central Bank of Nigeria (CBN)
#'
#' @description
#' A high-level interface to the CBN SDMX/REST API. This function mimics the
#' \code{quantmod::getSymbols} workflow, allowing for automatic workspace assignment
#' and local caching via the \code{pins} package.
#'
#' @param dataset Character. The unique ID or alias of the dataset (e.g., "inflation", "exchange_rates").
#' Use \code{discover_manifest()} to see available options.
#' @param variables Character vector. Specific indicator codes to filter the dataset. Defaults to NULL (all).
#' @param from Date or Character. Start date in "YYYY-MM-DD" format.
#' @param to Date or Character. End date in "YYYY-MM-DD" format. Defaults to today.
#' @param filters List. Advanced SDMX filter criteria.
#' @param raw Logical. If TRUE, returns the uncleaned API response. Defaults to FALSE.
#' @param canonical Logical. If TRUE, applies \code{opennaijR} standard cleaning and naming. Defaults to TRUE.
#' @param refresh Logical. If TRUE, bypasses the local cache and forces a fresh download. Defaults to FALSE.
#' @param auto.assign Logical. If TRUE, the data is assigned to a variable named after the \code{dataset}
#' in the specified environment. Defaults to TRUE.
#' @param env Environment. The environment where data is assigned when \code{auto.assign = TRUE}.
#' Defaults to \code{.GlobalEnv}.
#' @param quiet Logical. If TRUE, suppresses console messages during the fetch and pin process. Defaults to TRUE.
#'
#' @return
#' If \code{auto.assign = TRUE}, returns the name of the assigned object invisibly.
#' If \code{auto.assign = FALSE}, returns a tidy \code{data.frame} (or \code{tibble}).
#'
#' @details
#' The function automatically handles local caching. Data is stored in a
#' \code{pins} board to ensure subsequent calls for the same parameters are near-instant.
#'
#' @examples
#' \dontrun{
#' # The quantmod way (assigns to 'inflation' automatically)
#' nga_cbn("inflation")
#' head(inflation)
#'
#' # The standard way (returns data frame)
#' df <- nga_cbn("exchange_rates", auto.assign = FALSE)
#'
#' # Force a refresh of the data
#' nga_cbn("crude_oil", refresh = TRUE)
#' }
#'
#' @export
nga_cbn <- function(dataset,
                   variables = NULL,
                   from = NULL,
                   to = NULL,
                   filters = list(),
                   raw = FALSE,
                   canonical = TRUE,
                   refresh = FALSE,
                   auto.assign = TRUE,
                   env = .GlobalEnv,
                   quiet = TRUE) {

  # 1. Build intent
  q <- define_query(
    source    = "cbn",
    dataset   = dataset,
    variables = variables,
    filters   = filters,
    from      = from,
    to        = to
  )

  # 2. PIN CACHE CHECK
  board <- get_opennaijR_board()
  # Create a unique key for this specific query
  hash  <- digest::digest(list(variables = variables, from = from, to = to, filters = filters))
  pin_key <- paste("ng", q$intent$source, q$intent$dataset, hash, sep = "__")

  # Use suppressMessages to silence 'pins' and 'httr' chatter
  if (!refresh && pins::pin_exists(board, pin_key)) {
    data <- suppressMessages(read_pin_safe(board, pin_key))
  } else {
    # 3. Fetch & Ingest (Wrapped to stay silent)
    q <- suppressMessages(dispatch_request(q))
    q <- suppressMessages(ingest_payload(q))

    if (raw) {
      data <- q$parsed_data
    } else if (canonical && !is.null(q$manifest$standardize)) {
      # Standardize data internally
      q <- suppressMessages(canonicalize_data(q))
      data <- q$canonical_data
    } else {
      data <- q$parsed_data
    }

    # 4. Write to Pins silently
    suppressMessages(
      write_pin_safe(
        board,
        pin_key,
        data,
        metadata = list(country = "NG", source = "CBN", dataset = q$intent$dataset)
      )
    )
  }

  # Add attributes for package metadata
  attr(data, "source")  <- "CBN"
  attr(data, "dataset") <- q$intent$dataset
  attr(data, "country") <- "NG"

  # 5. Workspace Assignment (The quantmod/getSymbols style)
  if (auto.assign) {
    # Assign data to the specified environment (default: .GlobalEnv)
    assign(dataset, data, envir = env)
    # Return the name of the dataset as a string
    return(invisible(dataset))
  }

  return(data)
}
