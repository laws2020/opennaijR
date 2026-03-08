canonicalize_data <- function(query, backend = c("base", "data.table")) {

  backend <- match.arg(backend)

  stopifnot(
    is.list(query),
    !is.null(query$parsed_data),
    !is.null(query$manifest),
    !is.null(query$intent)
  )

  data     <- query$parsed_data
  manifest <- query$manifest
  intent   <- query$intent

  # --------------------------------
  # 1. Build canonical column map for measures
  # --------------------------------
  measures <- manifest$measures
  canonical_map <- stats::setNames(
    names(measures),
    base::vapply(measures, `[[`, "", "column")
  )

  # --------------------------------
  # 2. Select relevant columns (keep temporal + group + measures)
  # --------------------------------
  group_cols <- unlist(manifest$group %||% character())
  date_col   <- manifest$date$column %||% NULL
  temporal_cols <- c(date_col, "period")  # always keep period explicitly
  keep_cols <- c(temporal_cols, group_cols, names(canonical_map))
  keep_cols <- intersect(keep_cols, names(data))
  data <- data[, keep_cols, drop = FALSE]

  # --------------------------------
  # 3. Rename raw → canonical for measures only
  # --------------------------------
  idx <- names(data) %in% names(canonical_map)
  names(data)[idx] <- canonical_map[names(data)[idx]]

  # --------------------------------
  # 4. Parse date column (smart)
  # --------------------------------
  if (!is.null(date_col) && date_col %in% names(data)) {

    canonical_name <- manifest$date$name %||% date_col
    fmt <- manifest$date$format
    x <- data[[date_col]]

    # --- FORCE period column to Date ---
    if (canonical_name == "date" && date_col == "period") {
      data[[canonical_name]] <- lubridate::dmy(paste0("01 ", x))
    } else if (inherits(x, "Date")) {
      data[[canonical_name]] <- x
    } else if (!is.null(fmt)) {
      data[[canonical_name]] <- as.Date(x, format = fmt)
    } else {
      # --- SMART PARSER for other columns ---
      parsed <- suppressWarnings(as.Date(x, tryFormats = c(
        "%Y-%m-%d", "%Y/%m/%d", "%d-%m-%Y", "%m/%d/%Y"
      )))
      if (sum(!is.na(parsed)) / length(parsed) > 0.7) {
        data[[canonical_name]] <- parsed
      } else {
        parsed <- suppressWarnings(as.Date(paste0("01 ", x), format = "%d %B %Y"))
        data[[canonical_name]] <- parsed
      }
    }

    # Remove raw column if renamed
    if (canonical_name != date_col) data[[date_col]] <- NULL
  }

  # --------------------------------
  # 5. Enforce measure types
  # --------------------------------
  for (nm in names(measures)) {
    if (nm %in% names(data)) {
      data[[nm]] <- suppressWarnings(as.numeric(data[[nm]]))
    }
  }

  # --------------------------------
  # 6. Variable projection (optional)
  # --------------------------------
  if (!is.null(intent$variables)) {
    keep <- c(temporal_cols, group_cols, intent$variables)
    keep <- intersect(keep, names(data))
    data <- data[, keep, drop = FALSE]
  }

  # --------------------------------
  # 7. Backend coercion
  # --------------------------------
  if (backend == "data.table") {
    data <- data.table::as.data.table(data)
  }

  # --------------------------------
  # 8. Metadata
  # --------------------------------
  attr(data, "source")  <- intent$source
  attr(data, "dataset") <- intent$dataset
  class(data) <- unique(c("opennaijR_tbl", class(data)))

  # --------------------------------
  # 9. Reducer output
  # --------------------------------
  c(query, list(canonical_data = data))
}
