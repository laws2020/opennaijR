# Inflation Charts

### Overview

opennaijR ships two complementary plotting functions. Understanding the
difference between them is the first step to using them correctly.

| Function | What it draws | Best used for |
|----|----|----|
| [`plot_inflation_shocks()`](https://laws2020.github.io/opennaijR/reference/plot_inflation_shocks.md) | One inflation series with shock event markers | Showing *when* a policy shock hit and how prices responded |
| [`plot_inflation()`](https://laws2020.github.io/opennaijR/reference/plot_inflation.md) | Multiple inflation series on a single chart | Comparing headline, food, and core inflation side by side |

Both functions accept the `opennaijR_tbl` object returned by
[`cbn()`](https://laws2020.github.io/opennaijR/reference/cbn.md) and
produce `ggplot2`-compatible output. Neither requires any data reshaping
from you.

------------------------------------------------------------------------

## Part 1 – `plot_inflation_shocks()`

### What the Function Does

[`plot_inflation_shocks()`](https://laws2020.github.io/opennaijR/reference/plot_inflation_shocks.md)
draws an inflation time series and automatically overlays vertical
markers for significant Nigerian macroeconomic events. The shock markers
are built into the function – you do not configure them.

The events currently marked are:

| Event                     | Period                     |
|---------------------------|----------------------------|
| 2016 Oil Recession        | Full year 2016             |
| COVID-19 Pandemic         | March 2020 – December 2021 |
| 2023 Fuel Subsidy Removal | June 2023 onwards          |

### Arguments

| Argument | Type | Default | What it does |
|----|----|----|----|
| `data` | `data.frame` | required | Your dataset |
| `date_col` | `character` | `"date"` | Name of the date column |
| `val_col` | `character` | `"headline_yoy"` | Name of the numeric column to plot |
| `title` | `character` | `"Nigeria Inflation Trends"` | Plot title |

------------------------------------------------------------------------

### 1. Basic Usage

If your data comes from `cbn("inflation")`, the default column names
already match. One line produces a complete chart.

``` r
library(opennaijR)

infl <- cbn("inflation")

plot_inflation_shocks(infl)
```

You will see headline year-on-year inflation as a continuous line, three
shock markers drawn as vertical bands or lines, percentage labels on the
y-axis, and a source caption. All of that happens automatically.

------------------------------------------------------------------------

### 2. Switching the Inflation Measure

Nigeria’s headline figure is a weighted composite. `val_col` lets you
look beneath it at a specific component.

``` r
# Food inflation -- most sensitive to supply shocks and import costs
plot_inflation_shocks(
  data    = infl,
  val_col = "food_yoy",
  title   = "Nigeria Food Inflation Trends"
)
```

``` r
# Core inflation -- strips out farm produce and energy
plot_inflation_shocks(
  data    = infl,
  val_col = "core_ex_farm_yoy",
  title   = "Nigeria Core Inflation Trends"
)
```

**When to use each measure:**

- `headline_yoy` – the overall price level. Use this for general
  briefings and policy summaries.
- `food_yoy` – most volatile component. Use this when analysing food
  security, agricultural policy, or import dependency.
- `core_ex_farm_yoy` – strips food and energy to reveal underlying
  demand pressure. Preferred for monetary policy analysis because it is
  less distorted by supply shocks.

------------------------------------------------------------------------

### 3. Filtering to a Specific Period

Filter your data frame *before* passing it to the function to zoom into
a particular economic era. The shock markers will automatically show
only the events that fall within your filtered window.

``` r
# Focus on the post-COVID and subsidy-removal period
recent_data <- infl[infl$date >= as.Date("2020-01-01"), ]

plot_inflation_shocks(
  data  = recent_data,
  title = "Inflation Volatility: 2020 to Present"
)
```

``` r
# Isolate the 2016 recession era
recession_era <- infl[
  infl$date >= as.Date("2015-01-01") &
  infl$date <= as.Date("2018-12-01"),
]

plot_inflation_shocks(
  data  = recession_era,
  title = "Inflation During the 2016 Recession"
)
```

**Why filter rather than zoom the axis?** Filtering restricts the actual
data entering the function, which keeps the y-axis scale honest for the
period of interest. Zooming the axis without filtering compresses
variation and can mislead readers about the magnitude of change.

------------------------------------------------------------------------

### 4. Working with External Data

The function works with any data frame – not just CBN data. Use
`date_col` and `val_col` to tell it which columns to use.

``` r
external_df <- data.frame(
  period = seq(as.Date("2015-01-01"), as.Date("2024-01-01"), by = "month"),
  rate   = runif(109, 10, 30)
)

plot_inflation_shocks(
  data     = external_df,
  date_col = "period",
  val_col  = "rate",
  title    = "Custom Series with Nigerian Shock Overlay"
)
```

This is useful when you have NBS data, World Bank series, or any other
monthly indicator you want to view in the Nigerian macroeconomic
context.

------------------------------------------------------------------------

### 5. Plotting a Derived Measure

[`plot_inflation_shocks()`](https://laws2020.github.io/opennaijR/reference/plot_inflation_shocks.md)
works naturally after
[`derive_measure()`](https://laws2020.github.io/opennaijR/reference/derive_measure.md).
Engineer a feature and pass the result straight to the plot function –
no extra steps needed.

``` r
infl_gap <- derive_measure(
  infl,
  food_gap = food_yoy - headline_yoy,
  reason   = "Food premium over headline inflation"
)

plot_inflation_shocks(
  data    = infl_gap,
  val_col = "food_gap",
  title   = "Food Inflation Premium Over Headline"
)
```

A positive `food_gap` means food prices are rising faster than the
overall basket – a signal of food-specific supply pressure rather than
broad demand inflation. Plotting this gap against the shock markers
immediately shows which events triggered food-dominant inflation
episodes.

------------------------------------------------------------------------

### 6. Batch Comparison: Multiple Metrics

`par(mfrow)` stacks multiple plots in one graphics window. This is the
fastest way to compare how different components responded to the same
shock.

``` r
metrics <- c("headline_yoy", "food_yoy", "core_ex_farm_yoy")

labels  <- c(
  "Headline Inflation",
  "Food Inflation",
  "Core Inflation (Ex-Farm)"
)

par(mfrow = c(3, 1), mar = c(4, 4, 3, 1))

for (i in seq_along(metrics)) {
  plot_inflation_shocks(
    data    = infl,
    val_col = metrics[i],
    title   = labels[i]
  )
}

par(mfrow = c(1, 1))  # always reset the layout after use
```

**Reading the stacked output:** Align your eyes vertically at each shock
marker. If food spikes sharply at the 2023 subsidy removal but core
barely moves, the shock was a cost-push supply event, not demand-driven.
If both spike together, broad inflationary pressure is at work. That
distinction matters for policy response.

------------------------------------------------------------------------

### 7. Saving a Plot for a Report

``` r
png(
  filename = "nigeria_headline_inflation.png",
  width    = 2400,
  height   = 1500,
  res      = 300
)

plot_inflation_shocks(
  data  = infl,
  title = "Nigeria Headline Inflation with Macroeconomic Shocks"
)

dev.off()
```

Use [`pdf()`](https://rdrr.io/r/grDevices/pdf.html) instead of
[`png()`](https://rdrr.io/r/grDevices/png.html) for academic submissions
– PDF is vector-based and scales to any print size without losing
sharpness.

------------------------------------------------------------------------

------------------------------------------------------------------------

## Part 2 – `plot_inflation()`

### What the Function Does

Where
[`plot_inflation_shocks()`](https://laws2020.github.io/opennaijR/reference/plot_inflation_shocks.md)
focuses on *one* series and its policy context,
[`plot_inflation()`](https://laws2020.github.io/opennaijR/reference/plot_inflation.md)
is built for *comparison*. It puts headline, food, and core inflation on
the same chart using distinct coloured lines, so you can see how the
three components diverge and converge over time.

It also supports two measurement types – year-on-year rates and 12-month
averages – giving you a smoothed view of trends alongside the raw
monthly figures.

### Arguments

| Argument | Type | Default | What it does |
|----|----|----|----|
| `data` | `opennaijR_tbl` | required | Must be an `opennaijR_tbl` – plain data frames are rejected |
| `measure` | `character vector` | `c("headline", "food", "core")` | Which components to include. Pass one, two, or all three |
| `type` | `character` | `"yoy"` | Measurement type: `"yoy"` for year-on-year or `"12m"` for 12-month average |
| `title` | `character` | `"Nigeria Inflation Trends"` | Plot title |

**Important:** `data` must be the object returned by
[`cbn()`](https://laws2020.github.io/opennaijR/reference/cbn.md) – it
must carry the `opennaijR_tbl` class. If you pass a plain data frame the
function stops immediately with a clear error message.

------------------------------------------------------------------------

### 8. Default: All Three Components

``` r
plot_inflation(infl)
```

All three series – headline, food, and core – are drawn with distinct
colours and labelled in a legend at the bottom. The y-axis is formatted
as percentages automatically. The caption credits the CBN as the source.

------------------------------------------------------------------------

### 9. Plotting a Single Component

Pass one value to `measure` to isolate a single series. This is
equivalent to
[`plot_inflation_shocks()`](https://laws2020.github.io/opennaijR/reference/plot_inflation_shocks.md)
without the shock markers – cleaner for presentation slides where you do
not want the annotation clutter.

``` r
# Headline only
plot_inflation(
  data    = infl,
  measure = "headline",
  title   = "Nigeria Headline Inflation"
)
```

``` r
# Food only
plot_inflation(
  data    = infl,
  measure = "food",
  title   = "Nigeria Food Inflation"
)
```

------------------------------------------------------------------------

### 10. Comparing Two Components

Leave out whichever component is not relevant to your analysis.

``` r
# Headline vs Core -- useful for monetary policy analysis
# Core strips food and energy, so divergence signals supply-side pressure
plot_inflation(
  data    = infl,
  measure = c("headline", "core"),
  title   = "Headline vs Core Inflation"
)
```

``` r
# Headline vs Food -- how much is food driving the overall rate?
plot_inflation(
  data    = infl,
  measure = c("headline", "food"),
  title   = "Headline vs Food Inflation"
)
```

------------------------------------------------------------------------

### 11. Switching to 12-Month Averages

Year-on-year rates jump around month to month. The 12-month average
smooths that noise and makes the underlying trend easier to see. Use
`type = "12m"` to switch.

``` r
# Year-on-year -- shows monthly volatility
plot_inflation(
  data  = infl,
  type  = "yoy",
  title = "Nigeria Inflation: Year-on-Year"
)
```

``` r
# 12-month average -- shows the underlying trend
plot_inflation(
  data  = infl,
  type  = "12m",
  title = "Nigeria Inflation: 12-Month Average"
)
```

**When to choose each:**

- `"yoy"` – use when the monthly movement matters, such as tracking a
  recent spike or a sudden drop.
- `"12m"` – use when you want to show the structural trend, such as in
  an annual report or a conference presentation where you do not want
  the audience distracted by monthly noise.

------------------------------------------------------------------------

### 12. Combining measure and type

``` r
# Smoothed food and core -- structural comparison
plot_inflation(
  data    = infl,
  measure = c("food", "core"),
  type    = "12m",
  title   = "Food vs Core Inflation: 12-Month Trend"
)
```

------------------------------------------------------------------------

### 13. What Happens When a Column is Missing

[`plot_inflation()`](https://laws2020.github.io/opennaijR/reference/plot_inflation.md)
validates the requested columns before drawing anything. If a
combination of `measure` and `type` points to a column that does not
exist in your dataset, it stops and tells you exactly what is missing.

``` r
# If "core_ex_farm_12m" does not exist in your dataset:
plot_inflation(infl, measure = "core", type = "12m")
#> Error: Requested inflation measure(s) not found in data.
```

Check which columns your dataset actually contains with `names(infl)`
and confirm the column exists before using `type = "12m"`.

------------------------------------------------------------------------

------------------------------------------------------------------------

## Choosing Between the Two Functions

| You want to… | Use |
|----|----|
| Show one series and highlight when shocks occurred | [`plot_inflation_shocks()`](https://laws2020.github.io/opennaijR/reference/plot_inflation_shocks.md) |
| Compare two or three components on the same chart | [`plot_inflation()`](https://laws2020.github.io/opennaijR/reference/plot_inflation.md) |
| Smooth out monthly noise with a rolling average | [`plot_inflation()`](https://laws2020.github.io/opennaijR/reference/plot_inflation.md) with `type = "12m"` |
| Use non-CBN data with a Nigerian shock overlay | [`plot_inflation_shocks()`](https://laws2020.github.io/opennaijR/reference/plot_inflation_shocks.md) with `date_col` and `val_col` |
| Plot a derived measure (gap, dummy, ratio) | [`plot_inflation_shocks()`](https://laws2020.github.io/opennaijR/reference/plot_inflation_shocks.md) after [`derive_measure()`](https://laws2020.github.io/opennaijR/reference/derive_measure.md) |

------------------------------------------------------------------------

## Workflow Position

Both functions sit at the end of the opennaijR pipeline:

    cbn()  -->  apply_projection()  -->  derive_measure()  -->  plot

[`apply_projection()`](https://laws2020.github.io/opennaijR/reference/apply_projection.md)
and
[`derive_measure()`](https://laws2020.github.io/opennaijR/reference/derive_measure.md)
are optional steps – you can plot raw
[`cbn()`](https://laws2020.github.io/opennaijR/reference/cbn.md) output
directly. But when your analysis involves derived indicators or a
restricted set of columns, running those steps first gives you cleaner,
more meaningful charts.
