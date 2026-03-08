#' Derive new measures in an opennaijR_tbl with manifest tracking
#'
#' @description
#' `derive_measure()` calculates new variables from existing data,
#' such as YoY, MoM, rebased, or percentage changes.
#'
#' @param .data An `opennaijR_tbl` object
#' @param ... Named expressions for new measures
#' @param reason Optional description of why these measures are derived
#'
#' @return An `opennaijR_tbl`
#'
#' @examples
#' \dontrun{
#' # Retrieve CBN inflation dataset
#' infl <- cbn("inflation")   # returns opennaijR_tbl
#'
#' # 1. Derive difference between headline and food inflation
#' infl_diff <- derive_measure(
#'   infl,
#'   gap_headline_food = headline_yoy - food_yoy
#' )
#'
#' # 2. Derive percentage contribution of food inflation
#' infl_pct <- derive_measure(
#'   infl,
#'   food_share = (food_yoy / headline_yoy) * 100
#' )
#'
#' # 3. Compute month-to-month change of headline YoY
#' infl_mom_change <- derive_measure(
#'   infl,
#'   headline_yoy_change = headline_yoy - lag(headline_yoy)
#' )
#'
#' # 4. Chain multiple derived measures
#' infl_chain <- derive_measure(
#'   infl,
#'   gap = headline_yoy - core_ex_farm_yoy,
#'   energy_gap = core_ex_farm_energy_yoy - core_ex_farm_yoy,
#'   reason = "Compare structural inflation components"
#' )
#'
#' # 5. Inspect derivation manifest
#' attr(infl_chain, "derive_manifest")
#' }
#' @export
derive_measure <- function(.data, ..., reason = NULL) {
  stopifnot(inherits(.data, "opennaijR_tbl"))

  dots <- rlang::enquos(...)

  if (length(dots) == 0) {
    warning("No measures specified for derivation")
    return(.data)
  }

  df <- as.data.frame(.data)
  derived_names <- character()

  #reate data environment with helpers as parent
  data_env <- rlang::env(parent = .measure_helpers)
  rlang::env_bind(data_env, !!!df)

  mask <- rlang::new_data_mask(data_env)

  for (nm in names(dots)) {
    val <- rlang::eval_tidy(dots[[nm]], data = mask)

    val[is.nan(val) | is.infinite(val)] <- NA
    df[[nm]] <- val
    derived_names <- c(derived_names, nm)

    # keep environment in sync for chained measures
    data_env[[nm]] <- val
  }

  class(df) <- class(.data)

  manifest_entry <- list(
    timestamp   = Sys.time(),
    action      = "derive_measure",
    derived     = derived_names,
    expressions = sapply(dots, rlang::expr_text),
    reason      = reason
  )

  prev_manifest <- attr(.data, "derive_manifest")
  if (is.null(prev_manifest)) prev_manifest <- list()
  attr(df, "derive_manifest") <- c(prev_manifest, list(manifest_entry))

  df
}
