ingest_payload <- function(query) {
  req <- query$request

  # Safety: default to GET if NULL
  if (is.null(req$method)) req$method <- "GET"

  message("Fetching raw data from '", req$url, "' ...")

  resp <- httr::RETRY(
    verb = req$method,   # use method from request
    url  = req$url,
    times = 3,
    pause_base = 1,
    pause_cap  = 5,
    terminate_on = c(400, 401, 403, 404),
    httr::add_headers(Accept = "application/json"),
    httr::timeout(30)
  )

  status <- httr::status_code(resp)

  if (status != 200) {
    stop(
      sprintf("Request failed [%s]: %s",
              status,
              httr::http_status(resp)$message),
      call. = FALSE
    )
  }

  query$parsed_data <- jsonlite::fromJSON(
    httr::content(resp, as = "text", encoding = "UTF-8"),
    flatten = TRUE
  )

  query
}
