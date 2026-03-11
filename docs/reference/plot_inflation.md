# Plot Nigerian Inflation Trends

Creates a publication-ready inflation time-series plot from Central Bank
of Nigeria (CBN) inflation data retrieved via `cbn("inflation")`.

This function abstracts away data wrangling and applies economic-aware
defaults suitable for academic papers, policy briefs, and presentations.

## Usage

``` r
plot_inflation(
  data,
  measure = c("headline", "food", "core"),
  type = c("yoy", "12m"),
  title = NULL
)
```

## Arguments

- data:

  An `opennaijR_tbl` returned by `cbn("inflation")`.

- measure:

  Character vector. Inflation components to plot. One or more of
  `"headline"`, `"food"`, `"core"`.

- type:

  Character. `"yoy"` (year-on-year) or `"12m"` (12-month average).

- title:

  Optional plot title.

## Value

A `ggplot` object.

## Examples

``` r
if (FALSE) { # \dontrun{
infl <- cbn("inflation")

plot_inflation(infl)
plot_inflation(infl, measure = c("headline", "food"))
plot_inflation(infl, type = "12m")
} # }
```
