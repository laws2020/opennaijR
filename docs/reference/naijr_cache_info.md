# Inspect metadata for a cached dataset

Retrieves metadata (e.g., creation time, size) for a cached dataset.

## Usage

``` r
naijr_cache_info(name)
```

## Arguments

- name:

  Character scalar. Name of the cached dataset (as returned by
  [`naijr_cache_list()`](https://laws2020.github.io/opennaijR/reference/naijr_cache_list.md))

## Value

A list containing metadata for the dataset.

## Examples

``` r
if (FALSE) { # \dontrun{
pins <- naijr_cache_list()
naijr_cache_info(pins[1])
} # }
```
