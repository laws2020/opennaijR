#' Bind source metadata to a validated query (internal)
#'
#' @description
#' `bind_source()` validates a parsed query against the official
#' manifest registry and attaches the corresponding dataset metadata.
#'
#' This function:
#' - Normalizes the source and dataset identifiers
#' - Verifies that the source exists in `.manifest_registry()`
#' - Confirms that the dataset is defined for that source
#' - Attaches the dataset-level manifest to the query object
#'
#' It acts as a strict validation layer to ensure that only officially
#' registered data authorities and datasets are allowed in the pipeline.
#'
#' @param query A structured query object containing at least:
#'   - `query$intent$source`
#'   - `query$intent$dataset`
#'
#' @return The modified query object with a `manifest` element attached.
#'
#' @keywords internal
bind_source <- function(query) {

  # ---- Normalize inputs ----
  src <- tolower(trimws(query$intent$source))
  ds  <- tolower(trimws(query$intent$dataset))

  # ---- Load manifest for this source ----
  source_meta <- tryCatch(
    .manifest_registry(src),
    error = function(e) {
      stop(
        sprintf("Source '%s' is not a recognized official data authority.", src),
        call. = FALSE
      )
    }
  )

  dataset_keys <- names(source_meta)

  # ---- 1. Direct key match ----
  if (ds %in% dataset_keys) {
    query$manifest <- source_meta[[ds]]
    return(query)
  }

  # ---- 2. Alias match ----
  for (key in dataset_keys) {
    aliases <- source_meta[[key]]$aliases
    if (!is.null(aliases) && ds %in% tolower(aliases)) {
      query$manifest <- source_meta[[key]]
      return(query)
    }
  }

  # ---- If nothing matched ----
  stop(
    sprintf("Dataset '%s' is not defined for source '%s'.", ds, src),
    call. = FALSE
  )
}
