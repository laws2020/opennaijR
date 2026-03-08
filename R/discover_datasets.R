#' Discover Available Datasets and Variables
#'
#' @param source Character. Data source (cbn, nbs, wb, ngx).
#' @param dataset Character. Dataset identifier.
#'
#' @export
discover_datasets <- function(source = "cbn", dataset = NULL) {

  # -------------------------
  # Normalize sources
  # -------------------------
  sources <- tolower(source)
  manifests <- lapply(sources, .manifest_registry)

  # Combine multiple sources into one list
  manifest <- unlist(manifests, recursive = FALSE, use.names = TRUE)

  # Keep only proper dataset definitions
  manifest <- manifest[vapply(manifest, is.list, logical(1))]

  # -------------------------
  # Filter by dataset name or alias (partial match)
  # -------------------------
  if (!is.null(dataset)) {
    pattern <- tolower(dataset)

    manifest <- manifest[vapply(
      names(manifest),
      function(nm) {
        d <- manifest[[nm]]
        candidates <- c(nm, d$aliases %||% character())
        any(grepl(pattern, tolower(candidates)))
      },
      logical(1)
    )]
  }

  # -------------------------
  # Build friendly output
  # -------------------------
  tib <- tibble::tibble(
    dataset_key = names(manifest),
    dataset_id  = vapply(manifest, `[[`, character(1), "id"),
    source      = vapply(manifest, `[[`, character(1), "source"),
    aliases     = vapply(
      manifest,
      function(d) paste(d$aliases %||% character(), collapse = ", "),
      character(1)
    ),
    variables   = vapply(
      manifest,
      function(d) {
        if (is.list(d$measures)) paste(names(d$measures), collapse = ", ")
        else NA_character_
      },
      character(1)
    )
  )

  tib
}
