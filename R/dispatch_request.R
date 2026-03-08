dispatch_request <- function(query) {

  if (is.null(query$manifest)) {
    query <- bind_source(query)
  }

  query <- resolve_endpoint(query)

  base_urls <- list(
    cbn = "https://www.cbn.gov.ng/api/"
  )

  endpoint <- query$manifest$fetch$endpoint
  source   <- query$intent$source

  query$request <- list(
    url     = paste0(base_urls[[source]], endpoint),
    method  = query$manifest$fetch$method %||% "GET",
    headers = list(Accept = "application/json")
  )

  query$provenance <- list(
    retrieved_at = Sys.time(),
    source  = source,
    dataset = query$intent$dataset
  )

  query
}
