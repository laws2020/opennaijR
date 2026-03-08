resolve_endpoint <- function(query) {
  access <- query$manifest$access$method

  query$plan <- list(
    access_method = access,
    endpoint = sprintf(
      "internal://%s/%s",
      query$intent$source,
      query$intent$dataset
    ),
    version = "latest"
  )

  query
}
