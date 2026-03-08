# Fetching with nga_cbn()

## What is `nga_cbn()`?

[`nga_cbn()`](https://laws2020.github.io/opennaijR/reference/nga_cbn.md)
is the primary data retrieval function in opennaijR. It connects your R
session directly to the Central Bank of Nigeria (CBN) data
infrastructure, handles all cleaning and formatting automatically, and
delivers an analysis-ready object – all in one call.

The function name follows the opennaijR convention for all African data
sources:

    country_code  +  institution_code  +  ()
         nga       +       cbn         +  ()  =  nga_cbn()

When opennaijR expands to other countries, the same pattern applies
consistently:

    gha_bog()   -- Ghana, Bank of Ghana
    ken_cbk()   -- Kenya, Central Bank of Kenya
    zaf_sarb()  -- South Africa, South African Reserve Bank
    eth_nbe()   -- Ethiopia, National Bank of Ethiopia

A user who learns
[`nga_cbn()`](https://laws2020.github.io/opennaijR/reference/nga_cbn.md)
already understands every future function.

------------------------------------------------------------------------

## Arguments at a Glance

| Argument      | Type                 | Default                                      | What it does                                                                                                           |
|---------------|----------------------|----------------------------------------------|------------------------------------------------------------------------------------------------------------------------|
| `dataset`     | `character`          | required                                     | Dataset key or alias from [`discover_datasets()`](https://laws2020.github.io/opennaijR/reference/discover_datasets.md) |
| `variables`   | `character vector`   | `NULL`                                       | Specific indicator codes to retrieve. `NULL` returns all                                                               |
| `from`        | `character` / `Date` | `NULL`                                       | Start date in `"YYYY-MM-DD"` format                                                                                    |
| `to`          | `character` / `Date` | today                                        | End date in `"YYYY-MM-DD"` format                                                                                      |
| `filters`     | `list`               | [`list()`](https://rdrr.io/r/base/list.html) | Advanced SDMX filter criteria                                                                                          |
| `raw`         | `logical`            | `FALSE`                                      | If `TRUE`, returns the uncleaned API response                                                                          |
| `canonical`   | `logical`            | `TRUE`                                       | If `TRUE`, applies opennaijR standard cleaning and naming                                                              |
| `refresh`     | `logical`            | `FALSE`                                      | If `TRUE`, bypasses the local cache and downloads fresh data                                                           |
| `auto.assign` | `logical`            | `TRUE`                                       | If `TRUE`, assigns result to your environment automatically                                                            |
| `env`         | `environment`        | `.GlobalEnv`                                 | Where to assign the object when `auto.assign = TRUE`                                                                   |
| `quiet`       | `logical`            | `TRUE`                                       | If `TRUE`, suppresses console messages during fetch                                                                    |

------------------------------------------------------------------------

## Part 1 – The Two Retrieval Modes

[`nga_cbn()`](https://laws2020.github.io/opennaijR/reference/nga_cbn.md)
works in two distinct modes. Understanding the difference is the most
important thing to learn about this function.

------------------------------------------------------------------------

### Mode 1 – Auto-assign (the quantmod way)

``` r
library(opennaijR)

nga_cbn("inflation")

head(inflation)
```

Notice there is **no assignment operator**. You did not write
`inflation <- nga_cbn("inflation")`.

Instead,
[`nga_cbn()`](https://laws2020.github.io/opennaijR/reference/nga_cbn.md)
silently created a variable called `inflation` in your global
environment and placed the data there. The function returned the string
`"inflation"` invisibly – just the name, not the data.

This mirrors how `quantmod::getSymbols()` works, and it is the default
behaviour (`auto.assign = TRUE`).

**What you get in your environment:**

``` r
ls()
#> [1] "inflation"

class(inflation)
#> [1] "opennaijR_tbl" "data.frame"

head(inflation[, c("date", "headline_yoy", "food_yoy")])
#>         date headline_yoy food_yoy
#> 1 2010-01-01        11.80    14.60
#> 2 2010-02-01        14.05    17.02
```

------------------------------------------------------------------------

### Mode 2 – Explicit assignment (the standard R way)

``` r
df <- nga_cbn("exchange_rates", auto.assign = FALSE)

head(df)
```

Here `auto.assign = FALSE` tells the function to return the data frame
directly so you can assign it to any name you choose.

**When to use each mode:**

| Situation                                                                              | Use                            |
|----------------------------------------------------------------------------------------|--------------------------------|
| Interactive analysis at the top level                                                  | `auto.assign = TRUE` (default) |
| You want a custom variable name                                                        | `auto.assign = FALSE`          |
| Inside a function you are writing                                                      | `auto.assign = FALSE`          |
| Inside [`lapply()`](https://rdrr.io/r/base/lapply.html) or a loop that returns results | `auto.assign = FALSE`          |
| Building a pipeline with `|>`                                                          | `auto.assign = FALSE`          |

> **Important:** Never use `auto.assign = TRUE` inside a function body.
> It writes to `.GlobalEnv` silently, which produces hard-to-trace side
> effects. Always use `auto.assign = FALSE` in non-interactive code.

------------------------------------------------------------------------

## Part 2 – Loading Multiple Datasets

This is where `auto.assign = TRUE` becomes genuinely powerful. You can
retrieve several datasets in a loop without writing a separate
assignment for each one.

``` r
datasets <- c("inflation", "exchange_rates", "crude_oil")

for (key in datasets) {
  nga_cbn(key)
}

# All three now exist as named objects in your environment
ls()
#> [1] "crude_oil"      "exchange_rates" "inflation"

head(inflation)
head(exchange_rates)
head(crude_oil)
```

Each dataset key becomes its own variable name automatically. A
researcher building a macro model can load their full data universe in
three lines.

You can also use [`lapply()`](https://rdrr.io/r/base/lapply.html) for
the same result:

``` r
invisible(lapply(datasets, nga_cbn))
```

[`invisible()`](https://rdrr.io/r/base/invisible.html) suppresses the
character vector of names that
[`lapply()`](https://rdrr.io/r/base/lapply.html) would otherwise print
to the console.

------------------------------------------------------------------------

## Part 3 – Date Filtering

Use `from` and `to` to retrieve only the period you need. Both arguments
accept either a character string in `"YYYY-MM-DD"` format or an R `Date`
object.

### Retrieve from a specific start date

``` r
# All inflation data from January 2015 onwards
recent_infl <- nga_cbn(
  "inflation",
  from        = "2015-01-01",
  auto.assign = FALSE
)
```

### Retrieve a specific window

``` r
# The 2016 recession period only
recession <- nga_cbn(
  "inflation",
  from        = "2015-01-01",
  to          = "2018-12-31",
  auto.assign = FALSE
)
```

### Retrieve the most recent 12 months

``` r
# Dynamic: always retrieves the last 12 months regardless of when you run it
nga_cbn(
  "exchange_rates",
  from = as.character(Sys.Date() - 365),
  to   = as.character(Sys.Date())
)
```

------------------------------------------------------------------------

## Part 4 – Filtering Specific Variables

By default,
[`nga_cbn()`](https://laws2020.github.io/opennaijR/reference/nga_cbn.md)
returns every indicator in a dataset. Use `variables` to retrieve only
the columns you need. This is useful when a dataset is wide and you only
care about one or two series.

``` r
# Return only headline and food inflation -- skip all other columns
infl_narrow <- nga_cbn(
  "inflation",
  variables   = c("headline_yoy", "food_yoy"),
  auto.assign = FALSE
)

names(infl_narrow)
#> [1] "date"         "headline_yoy" "food_yoy"
```

------------------------------------------------------------------------

## Part 5 – Cache Management with `refresh`

opennaijR caches every download locally using the `pins` package. After
the first call, subsequent calls to the same dataset load from disk and
are nearly instant – no network request is made.

``` r
# First call -- downloads from CBN (takes a moment)
nga_cbn("inflation")

# Second call -- loads from local cache (instant)
nga_cbn("inflation")
```

### When to use `refresh = TRUE`

The CBN periodically revises historical data and publishes new monthly
figures. Your local cache does not update automatically. Use
`refresh = TRUE` when:

- A new month of data has been published
- You suspect the CBN has revised historical figures
- You want to verify your results against the latest official release

``` r
# Bypass the cache and download the latest data
nga_cbn("inflation", refresh = TRUE)
```

``` r
# Refresh and capture explicitly
infl_latest <- nga_cbn(
  "inflation",
  refresh     = TRUE,
  auto.assign = FALSE
)
```

------------------------------------------------------------------------

## Part 6 – Raw vs Canonical Output

### Canonical output (default)

``` r
infl_clean <- nga_cbn(
  "inflation",
  canonical   = TRUE,    # this is the default
  auto.assign = FALSE
)

names(infl_clean)
#> [1] "date"             "headline_yoy"     "food_yoy"
#>     "core_ex_farm_yoy" ...
```

`canonical = TRUE` applies the full opennaijR cleaning pipeline:

- Column names are normalised to `snake_case`
- Date strings are parsed into R `Date` objects
- The dataset is reshaped to tidy format
- The object carries `opennaijR_tbl` class and source attributes

This is the output that
[`apply_projection()`](https://laws2020.github.io/opennaijR/reference/apply_projection.md)
and
[`derive_measure()`](https://laws2020.github.io/opennaijR/reference/derive_measure.md)
expect.

### Raw output

``` r
infl_raw <- nga_cbn(
  "inflation",
  raw         = TRUE,
  auto.assign = FALSE
)

# Inspect what the CBN API actually returns before any cleaning
str(infl_raw)
```

`raw = TRUE` returns the API response exactly as received – messy column
names, string dates, and all. Use this when:

- You are debugging a connector
- You want to inspect what the CBN actually publishes before cleaning
- You are building a custom parser and need the source structure

> Do not use `raw = TRUE` for analysis. The canonical output is always
> preferable for any downstream work.

------------------------------------------------------------------------

## Part 7 – Controlling the Assignment Environment

By default, `auto.assign = TRUE` writes to `.GlobalEnv`. You can
redirect this to a different environment using `env`.

``` r
# Create a dedicated environment for macro data
macro_env <- new.env(parent = emptyenv())

# Load datasets into that environment instead of .GlobalEnv
nga_cbn("inflation",     env = macro_env)
nga_cbn("exchange_rates", env = macro_env)

# Access them through the environment
ls(macro_env)
#> [1] "exchange_rates" "inflation"

head(macro_env$inflation)
```

This keeps your global environment clean when working with many
datasets, and is the correct pattern for package development or Shiny
applications where polluting `.GlobalEnv` is unacceptable.

------------------------------------------------------------------------

## Part 8 – Full Pipeline Integration

[`nga_cbn()`](https://laws2020.github.io/opennaijR/reference/nga_cbn.md)
with `auto.assign = FALSE` slots directly into a pipeline:

``` r
library(opennaijR)

nga_cbn("inflation", auto.assign = FALSE) |>
  apply_projection(
    cols   = c("date", "headline_yoy", "food_yoy"),
    rename = c(Date = "date", Headline = "headline_yoy", Food = "food_yoy"),
    reason = "Select key series"
  ) |>
  derive_measure(
    gap         = Headline - Food,
    accelerating = Headline > lag(Headline),
    reason      = "Diagnostic indicators"
  ) |>
  plot_inflation_shocks(
    val_col = "Headline",
    title   = "Nigeria Headline Inflation"
  )
```

From raw CBN data to a fully annotated chart in four lines.

------------------------------------------------------------------------

## Part 9 – The Future Pattern

When opennaijR expands to other African countries, every new function
will follow the same interface as
[`nga_cbn()`](https://laws2020.github.io/opennaijR/reference/nga_cbn.md).
The arguments, the caching behaviour, the `auto.assign` pattern, and the
canonical output will all work identically. Only the function name
changes.

``` r
# Ghana -- Bank of Ghana
gha_bog("inflation", from = "2015-01-01")

# Kenya -- Central Bank of Kenya
ken_cbk("exchange_rates", auto.assign = FALSE)

# South Africa -- South African Reserve Bank
zaf_sarb("inflation", refresh = TRUE)

# Load inflation data from four countries in one loop
sources <- list(
  nga = "nga_cbn",
  gha = "gha_bog",
  ken = "ken_cbk",
  zaf = "zaf_sarb"
)

for (fn in sources) {
  do.call(fn, list("inflation"))
}
```

A researcher doing a comparative African inflation study loads all four
countries’ data with the same loop structure – no special cases, no
different arguments, no surprises.

------------------------------------------------------------------------

## Quick Reference

``` r
# Load and auto-assign
nga_cbn("inflation")

# Load and assign yourself
df <- nga_cbn("inflation", auto.assign = FALSE)

# Load multiple datasets at once
invisible(lapply(c("inflation", "exchange_rates"), nga_cbn))

# Filter to a date range
nga_cbn("inflation", from = "2020-01-01", to = "2023-12-31")

# Filter to specific variables
nga_cbn("inflation", variables = c("headline_yoy", "food_yoy"),
        auto.assign = FALSE)

# Force fresh download
nga_cbn("inflation", refresh = TRUE)

# Get raw uncleaned API response
nga_cbn("inflation", raw = TRUE, auto.assign = FALSE)

# Load into a specific environment
nga_cbn("inflation", env = macro_env)

# Full pipeline
nga_cbn("inflation", auto.assign = FALSE) |>
  apply_projection(cols = c("date", "headline_yoy")) |>
  derive_measure(accel = headline_yoy - lag(headline_yoy))
```
