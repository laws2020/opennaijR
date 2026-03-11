# Fill Missing Values in Datasets

Provides multiple methods to impute missing values (NAs) in Nigerian
datasets, supporting KNN, Linear Interpolation, and LOCF.

## Usage

``` r
ng_fill_missing(data, method = c("locf", "knn", "linear"), k = 5, cols = NULL)
```

## Arguments

- data:

  A data frame or tibble.

- method:

  Character. The imputation method: "knn", "linear", or "locf". Defaults
  to "locf" (best for time-series).

- k:

  Integer. Number of neighbors to use if method is "knn". Defaults to 5.

- cols:

  Character vector. Specific columns to fill. If NULL, applies to all
  numeric columns.

## Value

A data frame with missing values filled.
