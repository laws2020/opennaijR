# Access Central Bank of Nigeria (CBN) datasets

`cbn()` provides a unified interface for retrieving datasets published
by the Central Bank of Nigeria (CBN). It supports dataset aliasing,
variable selection, date filtering, optional canonicalization, and
access to raw or parsed data.

The function follows a strict pipeline:

1.  Define query intent

2.  Dispatch request (raw fetch only)

3.  Interpret payload (parse)

4.  Canonicalize (optional)

## Usage

``` r
cbn(
  dataset,
  variables = NULL,
  from = NULL,
  to = NULL,
  filters = list(),
  raw = FALSE,
  canonical = TRUE,
  refresh = FALSE
)
```

## Arguments

- dataset:

  Character scalar. Name or alias of the CBN dataset to retrieve (e.g.
  `"inflation_ng"`, `"exchange_rate"`).

- variables:

  Character vector or `NULL`. Optional subset of variables (columns) to
  return. If `NULL`, all available variables are returned.

- from, to:

  Date or character coercible to `Date`, or `NULL`. Optional date range
  for time-series datasets.

- filters:

  Named list. Optional key-value filters applied at the query definition
  stage.

- raw:

  Logical. If `TRUE`, returns parsed data immediately after payload
  interpretation, skipping canonicalization.

- canonical:

  Logical. If `TRUE` (default), applies dataset-specific
  canonicalization when a standardization function is defined in the
  manifest.

- refresh:

  Logical. If `TRUE`, forces a fresh download by bypassing any cached
  version of the dataset. Default is `FALSE`.

## Value

A data frame (or tibble) containing:

- Canonicalized data if `canonical = TRUE`

- Parsed raw data if `canonical = FALSE` or `raw = TRUE`

## Details

Canonicalization standardizes column names, data types, and structures
across datasets to ensure consistency for analysis and downstream
integration.

When `raw = TRUE`, canonicalization is bypassed regardless of the value
of `canonical`.

## See also

define_query(), dispatch_request(), interpret_payload(),
canonicalize_data()

## Examples

``` r
if (FALSE) { # \dontrun{
cbn("inflation_ng")
cbn("exchange_rates", canonical = FALSE)
cbn("exchange_rates", raw = TRUE)
} # }
```
