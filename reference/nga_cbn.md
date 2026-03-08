# Fetch Data from the Central Bank of Nigeria (CBN)

A high-level interface to the CBN SDMX/REST API. This function mimics
the `quantmod::getSymbols` workflow, allowing for automatic workspace
assignment and local caching via the `pins` package.

## Usage

``` r
nga_cbn(
  dataset,
  variables = NULL,
  from = NULL,
  to = NULL,
  filters = list(),
  raw = FALSE,
  canonical = TRUE,
  refresh = FALSE,
  auto.assign = TRUE,
  env = .GlobalEnv,
  quiet = TRUE
)
```

## Arguments

- dataset:

  Character. The unique ID or alias of the dataset (e.g., "inflation",
  "exchange_rates"). Use `discover_manifest()` to see available options.

- variables:

  Character vector. Specific indicator codes to filter the dataset.
  Defaults to NULL (all).

- from:

  Date or Character. Start date in "YYYY-MM-DD" format.

- to:

  Date or Character. End date in "YYYY-MM-DD" format. Defaults to today.

- filters:

  List. Advanced SDMX filter criteria.

- raw:

  Logical. If TRUE, returns the uncleaned API response. Defaults to
  FALSE.

- canonical:

  Logical. If TRUE, applies `opennaijR` standard cleaning and naming.
  Defaults to TRUE.

- refresh:

  Logical. If TRUE, bypasses the local cache and forces a fresh
  download. Defaults to FALSE.

- auto.assign:

  Logical. If TRUE, the data is assigned to a variable named after the
  `dataset` in the specified environment. Defaults to TRUE.

- env:

  Environment. The environment where data is assigned when
  `auto.assign = TRUE`. Defaults to `.GlobalEnv`.

- quiet:

  Logical. If TRUE, suppresses console messages during the fetch and pin
  process. Defaults to TRUE.

## Value

If `auto.assign = TRUE`, returns the name of the assigned object
invisibly. If `auto.assign = FALSE`, returns a tidy `data.frame` (or
`tibble`).

## Details

The function automatically handles local caching. Data is stored in a
`pins` board to ensure subsequent calls for the same parameters are
near-instant.

## Examples

``` r
if (FALSE) { # \dontrun{
# The quantmod way (assigns to 'inflation' automatically)
nga_cbn("inflation")
head(inflation)

# The standard way (returns data frame)
df <- nga_cbn("exchange_rates", auto.assign = FALSE)

# Force a refresh of the data
nga_cbn("crude_oil", refresh = TRUE)
} # }
```
