# Clear opennaijR cache

Clear opennaijR cache

## Usage

``` r
naijr_cache_clear(dataset = NULL, all = FALSE)
```

## Arguments

- dataset:

  Character scalar. Dataset name (e.g., "fx_reserves").

- all:

  Logical. If TRUE, clears the entire cache.

## Value

Invisibly TRUE if successful, FALSE otherwise.

## Examples

``` r
if (FALSE) { # \dontrun{
naijr_cache_clear("fx_reserves")
naijr_cache_clear(all = TRUE)
} # }
```
