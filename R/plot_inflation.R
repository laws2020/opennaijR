#' Plot Nigerian Inflation Trends
#'
#' @description
#' Creates a publication-ready inflation time-series plot from
#' Central Bank of Nigeria (CBN) inflation data retrieved via
#' `cbn("inflation")`.
#'
#' This function abstracts away data wrangling and applies
#' economic-aware defaults suitable for academic papers,
#' policy briefs, and presentations.
#'
#' @param data An `opennaijR_tbl` returned by `cbn("inflation")`.
#'
#' @param measure Character vector. Inflation components to plot.
#' One or more of `"headline"`, `"food"`, `"core"`.
#'
#' @param type Character. `"yoy"` (year-on-year) or `"12m"` (12-month average).
#'
#' @param title Optional plot title.
#'
#' @return A `ggplot` object.
#'
#' @examples
#' \dontrun{
#' infl <- cbn("inflation")
#'
#' plot_inflation(infl)
#' plot_inflation(infl, measure = c("headline", "food"))
#' plot_inflation(infl, type = "12m")
#' }
#' @importFrom graphics par rect abline text
#' @export
plot_inflation <- function(data,
                           measure = c("headline", "food", "core"),
                           type = c("yoy", "12m"),
                           title = NULL) {

  stopifnot(inherits(data, "opennaijR_tbl"))

  type <- match.arg(type)

  measure_map <- list(
    headline = paste0("headline_", type),
    food     = paste0("food_", type),
    core     = paste0("core_ex_farm_", type)
  )

  vars <- unlist(measure_map[measure], use.names = FALSE)

  missing <- setdiff(vars, names(data))
  if (length(missing) > 0) {
    stop("Requested inflation measure(s) not found in data.", call. = FALSE)
  }

  df <- data |>
    dplyr::select(date, dplyr::all_of(vars)) |>
    tidyr::pivot_longer(
      -date,
      names_to = "series",
      values_to = "value"
    )

  label_map <- c(
    headline_yoy = "Headline Inflation",
    food_yoy = "Food Inflation",
    core_ex_farm_yoy = "Core Inflation",
    headline_12m = "Headline (12-month avg)",
    food_12m = "Food (12-month avg)",
    core_ex_farm_12m = "Core (12-month avg)"
  )

  df$series <- label_map[df$series]

  ggplot2::ggplot(df, ggplot2::aes(date, value, colour = series)) +
    ggplot2::geom_line(linewidth = 1.1) +
    ggplot2::scale_y_continuous(labels = scales::percent_format(scale = 1)) +
    ggplot2::labs(
      title = title %||% "Nigeria Inflation Trends",
      x = NULL,
      y = "Inflation Rate (%)",
      colour = NULL,
      caption = "Source: Central Bank of Nigeria (CBN)"
    ) +
    ggplot2::theme_minimal(base_size = 12) +
    ggplot2::theme(
      plot.title = ggplot2::element_text(face = "bold"),
      legend.position = "bottom"
    )
}
