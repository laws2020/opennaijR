#' Project, filter, and reshape an opennaijR dataset with manifest tracking
#'
#' @description
#' `apply_projection()` performs filtering and projection on an `opennaijR_tbl`,
#' allowing row filtering, column selection, renaming, and ordering.
#' It records a **projection manifest** for reproducibility.
#'
#' @param .data An `opennaijR_tbl` object, typically returned by [cbn()].
#' @param filter Optional filtering condition (unquoted expression).
#' @param cols Character vector or NULL. Columns to keep. All columns if NULL.
#' @param rename Named character vector or NULL. Rename spec: c(new = "old").
#' @param order Character vector or NULL. Optional final column order.
#' @param reason Optional description of why this projection is applied.
#'
#' @return An `opennaijR_tbl` with applied transformations and manifest.
#'
#' @export
apply_projection <- function(.data,
                             filter = NULL,
                             cols = NULL,
                             rename = NULL,
                             order = NULL,
                             reason = NULL) {

  stopifnot(inherits(.data, "opennaijR_tbl"))

  df <- .data

  # Capture filter ONCE
  filter_quo <- rlang::enquo(filter)

  # -------------------------
  # Row filtering
  # -------------------------
  if (!rlang::quo_is_null(filter_quo)) {
    df <- df[rlang::eval_tidy(filter_quo, df), , drop = FALSE]
  }

  # -------------------------
  # Column selection
  # -------------------------
  if (!is.null(cols)) {
    missing_cols <- setdiff(cols, names(df))
    if (length(missing_cols)) {
      stop(sprintf("Unknown column(s) in projection: %s",
                   paste(missing_cols, collapse = ", ")),
           call. = FALSE)
    }
    df <- df[, cols, drop = FALSE]
  }

  # -------------------------
  # Rename columns
  # -------------------------
  if (!is.null(rename)) {
    if (is.null(names(rename))) {
      stop("`rename` must be a named vector: c(new_name = 'old_name')",
           call. = FALSE)
    }

    old <- unname(rename)
    new <- names(rename)

    missing <- setdiff(old, names(df))
    if (length(missing)) {
      stop(sprintf("Cannot rename missing column(s): %s",
                   paste(missing, collapse = ", ")),
           call. = FALSE)
    }

    names(df)[match(old, names(df))] <- new
  }

  # -------------------------
  # Column ordering
  # -------------------------
  if (!is.null(order)) {
    missing_order <- setdiff(order, names(df))
    if (length(missing_order)) {
      stop(sprintf("Cannot order missing column(s): %s",
                   paste(missing_order, collapse = ", ")),
           call. = FALSE)
    }

    df <- df[, order, drop = FALSE]
  }

  # Restore class
  class(df) <- class(.data)

  # -------------------------
  # Attach projection manifest
  # -------------------------
  manifest_entry <- list(
    timestamp = Sys.time(),
    action    = "apply_projection",
    filter    = if (!rlang::quo_is_null(filter_quo))
      rlang::expr_text(filter_quo)
    else NULL,
    kept      = if (is.null(cols)) names(.data) else cols,
    renamed   = if (is.null(rename)) NULL else rename,
    ordered   = if (is.null(order)) NULL else order,
    reason    = reason
  )

  prev_manifest <- attr(.data, "projection_manifest")
  if (is.null(prev_manifest)) prev_manifest <- list()

  attr(df, "projection_manifest") <- c(prev_manifest, list(manifest_entry))

  df
}
