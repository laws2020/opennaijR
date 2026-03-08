# Feature Engineering with derive_measure()

## What is `derive_measure()`?

The CBN dataset gives you raw figures — year-on-year inflation rates,
exchange rate quotes, money supply totals.
[`derive_measure()`](https://laws2020.github.io/opennaijR/reference/derive_measure.md)
lets you turn those raw figures into *analytically meaningful*
quantities: gaps, ratios, regime flags, rolling trends, and anything
else you can express as an R expression.

The key design principle is that you write your formula directly inside
the function call, referencing column names as bare variable names — no
`$`, no `[[]]`. The function evaluates each expression against the
dataset and appends the result as a new column. The original columns are
always preserved.

Every derived measure is logged in a `derive_manifest` attribute for
reproducibility.

------------------------------------------------------------------------

## Input and Output

| Argument | Type                           | What it does                                            |
|----------|--------------------------------|---------------------------------------------------------|
| `.data`  | `data.frame` / `opennaijR_tbl` | Your dataset (raw or projected)                         |
| `...`    | Named expressions              | `new_col_name = <expression>` — one per derived measure |
| `reason` | `character scalar`             | Optional label stored in the manifest                   |

**Output:** The same dataset with one new column appended per
expression. The class and all existing columns are untouched. A
`derive_manifest` attribute is added (or appended if one already
exists).

------------------------------------------------------------------------

## 1. Simple Arithmetic Differences

The most common use: compute the gap between two indicators.

``` r
library(opennaijR)

infl <- cbn("inflation")

# How far is headline above food inflation in each period?
infl_gap <- derive_measure(
  infl,
  gap_headline_food = headline_yoy - food_yoy
)

head(infl_gap[, c("date", "headline_yoy", "food_yoy", "gap_headline_food")])
```

The new column `gap_headline_food` appears at the right of the data
frame. Everything else is unchanged.

------------------------------------------------------------------------

## 2. Percentage Shares and Ratios

``` r
# What fraction of headline inflation is food-driven?
infl_share <- derive_measure(
  infl,
  food_share_pct = (food_yoy / headline_yoy) * 100
)

# How does core compare to headline?
infl_ratio <- derive_measure(
  infl,
  core_to_headline = core_ex_farm_yoy / headline_yoy
)
```

> **Note on division by zero:** If `headline_yoy` is ever zero, the
> ratio will produce `Inf` or `NaN`.
> [`derive_measure()`](https://laws2020.github.io/opennaijR/reference/derive_measure.md)
> automatically converts both to `NA` so your downstream analysis is not
> silently corrupted.

------------------------------------------------------------------------

## 3. Absolute Values

``` r
infl_abs <- derive_measure(
  infl,
  abs_gap = abs(headline_yoy - core_ex_farm_yoy)
)
```

Use absolute gaps when you care about magnitude, not direction.

------------------------------------------------------------------------

## 4. Time-Series Transformations with `lag()`

[`lag()`](https://dplyr.tidyverse.org/reference/lead-lag.html) shifts a
column back by one period, giving you the previous observation. This is
the foundation of all momentum and change indicators.

### Month-to-month change

``` r
infl_mom <- derive_measure(
  infl,
  headline_change = headline_yoy - lag(headline_yoy)
)
```

### Percentage growth rate

``` r
infl_growth <- derive_measure(
  infl,
  headline_growth_pct =
    (headline_yoy - lag(headline_yoy)) / lag(headline_yoy) * 100
)
```

### Year-on-year delta (12-month lag)

``` r
infl_annual_delta <- derive_measure(
  infl,
  annual_delta = headline_yoy - lag(headline_yoy, 12)
)
```

`lag(x, n)` shifts by `n` periods, so `lag(headline_yoy, 12)` gives you
the value from twelve months ago.

------------------------------------------------------------------------

## 5. Rolling Averages

If [`rollmean()`](https://rdrr.io/pkg/zoo/man/rollmean.html) from the
`zoo` package is available in your environment:

``` r
library(zoo)

infl_roll <- derive_measure(
  infl,
  headline_3m_avg = rollmean(headline_yoy, k = 3, fill = NA, align = "right")
)
```

The `fill = NA` argument ensures the first two rows (where a 3-month
window cannot be formed) are `NA` rather than dropped.

------------------------------------------------------------------------

## 6. Boolean / Dummy Variables

Any expression that returns `TRUE` or `FALSE` becomes an indicator
column — very useful for dashboards, filtering, and regression dummy
variables.

``` r
# Is inflation accelerating this period compared to last?
infl_accel <- derive_measure(
  infl,
  accelerating = headline_yoy > lag(headline_yoy)
)

# Is food inflation the dominant driver?
infl_food_driven <- derive_measure(
  infl,
  food_dominant = food_yoy > headline_yoy
)
```

------------------------------------------------------------------------

## 7. Conditional Classification with `ifelse()`

Use nested [`ifelse()`](https://rdrr.io/r/base/ifelse.html) to build
regime categories.

``` r
infl_regime <- derive_measure(
  infl,
  inflation_class = ifelse(
    headline_yoy < 0,  "Deflation",
    ifelse(
      headline_yoy <= 5,  "Low",
      ifelse(
        headline_yoy <= 15, "Moderate",
        "High"
      )
    )
  ),
  reason = "Three-level inflation regime classification"
)
```

**Reading the logic step by step:**

- If `headline_yoy < 0` → `"Deflation"`
- Else if `headline_yoy <= 5` → `"Low"`
- Else if `headline_yoy <= 15` → `"Moderate"`
- Else → `"High"`

The same pattern scales to as many levels as you need.

------------------------------------------------------------------------

## 8. Numeric Regime Codes (for Regression Models)

Statistical models often require numeric encoding rather than character
labels.

``` r
infl_regime_num <- derive_measure(
  infl,
  regime_code = ifelse(
    headline_yoy < 0,   0L,
    ifelse(
      headline_yoy <= 5,  1L,
      ifelse(
        headline_yoy <= 15, 2L,
        3L
      )
    )
  ),
  reason = "Numeric regime encoding for regression"
)
```

Now `regime_code` takes values 0, 1, 2, or 3 and can be used directly in
[`lm()`](https://rdrr.io/r/stats/lm.html) or
[`glm()`](https://rdrr.io/r/stats/glm.html).

------------------------------------------------------------------------

## 9. Creating Multiple Measures in One Call

You are not limited to one expression. Pass as many named expressions as
you like — they are computed in order, so a later expression can
reference an earlier derived column.

``` r
infl_decomp <- derive_measure(
  infl,
  gap            = headline_yoy - core_ex_farm_yoy,
  food_pressure  = food_yoy     - core_ex_farm_yoy,
  accelerating   = headline_yoy > lag(headline_yoy),
  high_regime    = headline_yoy > 15,
  reason         = "Full structural decomposition for policy brief"
)
```

One function call, four new columns, one manifest entry.

------------------------------------------------------------------------

## 10. Chaining Calls (Manifest Accumulation)

Just as with
[`apply_projection()`](https://laws2020.github.io/opennaijR/reference/apply_projection.md),
you can pipe the output of one
[`derive_measure()`](https://laws2020.github.io/opennaijR/reference/derive_measure.md)
call into the next. Each call adds an entry to the manifest.

``` r
step1 <- derive_measure(
  infl,
  gap = headline_yoy - food_yoy,
  reason = "Compute baseline gap"
)

step2 <- derive_measure(
  step1,
  gap_change = gap - lag(gap),
  reason = "Measure whether gap is widening"
)

# Both derivation steps are recorded
manifest <- attr(step2, "derive_manifest")

manifest[[1]]$expressions  # step 1 expressions
manifest[[2]]$expressions  # step 2 expressions
```

------------------------------------------------------------------------

## 11. Inspecting the Manifest

``` r
infl_features <- derive_measure(
  infl,
  gap   = headline_yoy - food_yoy,
  share = (food_yoy / headline_yoy) * 100,
  reason = "Replication of 2025 inflation study"
)

manifest <- attr(infl_features, "derive_manifest")

manifest[[1]]$timestamp    # Exact time the function ran
manifest[[1]]$expressions  # The R expressions that were evaluated
manifest[[1]]$reason       # Your label
```

This is your proof of work. A collaborator or journal reviewer can
inspect the manifest and verify exactly what was computed and when.

------------------------------------------------------------------------

## 12. Pipe-Friendly Usage

``` r
library(dplyr)

model_ready <- infl |>
  derive_measure(
    gap        = headline_yoy - core_ex_farm_yoy,
    accel      = headline_yoy - lag(headline_yoy),
    high_regime = headline_yoy > 15,
    reason     = "Feature set for regression model"
  )
```

------------------------------------------------------------------------

## 13. Exchange Rate Feature Engineering

[`derive_measure()`](https://laws2020.github.io/opennaijR/reference/derive_measure.md)
works on any `opennaijR_tbl`, not just inflation data.

``` r
exchange <- cbn("exchange_rates")

exchange_features <- derive_measure(
  exchange,
  spread       = selling_rate - buying_rate,
  mid_rate     = (buying_rate + selling_rate) / 2,
  buying_pct   = (buying_rate - lag(buying_rate)) / lag(buying_rate) * 100,
  depreciation = buying_rate > lag(buying_rate),
  movement     = ifelse(
    buying_rate > lag(buying_rate), "Depreciation",
    ifelse(buying_rate < lag(buying_rate), "Appreciation", "Stable")
  ),
  reason = "Exchange rate feature engineering"
)
```

In a single call you have: spread, mid-market rate, percentage change, a
boolean flag, and a character classification.

------------------------------------------------------------------------

## 14. Cross-Dataset Features

After merging inflation and exchange rate data, you can derive
indicators that combine both sources.

``` r
infl_std    <- apply_projection(infl,     rename = c(Date = "date"))
exchange_std <- apply_projection(exchange, rename = c(Date = "ratedate"))

macro <- merge(infl_std, exchange_std, by = "Date")

macro_features <- derive_measure(
  macro,
  real_exchange_change = buying_pct - headline_yoy,
  reason = "Compare currency depreciation against inflation"
)
```

------------------------------------------------------------------------

## 15. Error and Edge Cases

| Situation                                           | Behaviour                                             |
|-----------------------------------------------------|-------------------------------------------------------|
| No expressions provided                             | A warning is issued; data is returned unchanged       |
| Expression produces `Inf` or `NaN`                  | Automatically converted to `NA`                       |
| Column name referenced in expression does not exist | Standard R evaluation error naming the missing object |

------------------------------------------------------------------------

## Workflow Position

[`derive_measure()`](https://laws2020.github.io/opennaijR/reference/derive_measure.md)
sits immediately after
[`apply_projection()`](https://laws2020.github.io/opennaijR/reference/apply_projection.md)
in the opennaijR pipeline:

    cbn()  →  apply_projection()  →  derive_measure()  →  analysis / modeling

[`apply_projection()`](https://laws2020.github.io/opennaijR/reference/apply_projection.md)
gives you a clean schema;
[`derive_measure()`](https://laws2020.github.io/opennaijR/reference/derive_measure.md)
gives you analytically rich features. Together they transform a raw API
response into a research-ready dataset.
