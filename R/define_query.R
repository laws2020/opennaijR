define_query <- function(
    source,
    dataset,
    variables = NULL,
    filters = list(),
    from = NULL,
    to = NULL
) {
  structure(
    list(
      intent = list(
        source    = tolower(source),
        dataset   = dataset,
        variables = variables,
        filters   = filters,
        from      = from,
        to        = to
      ),
      manifest   = NULL,
      plan       = NULL,
      provenance = NULL,
      metadata   = list(
        query_id   = paste0("qn_", uuid::UUIDgenerate()),
        created_at = Sys.time()
      )
    ),
    class = "opennaij_query"
  )
}
