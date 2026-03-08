# Project, filter, and reshape an opennaijR dataset with manifest tracking

`apply_projection()` performs filtering and projection on an
`opennaijR_tbl`, allowing row filtering, column selection, renaming, and
ordering. It records a **projection manifest** for reproducibility.

## Usage

``` r
apply_projection(
  .data,
  filter = NULL,
  cols = NULL,
  rename = NULL,
  order = NULL,
  reason = NULL
)
```

## Arguments

- .data:

  An `opennaijR_tbl` object, typically returned by
  [`cbn()`](https://laws2020.github.io/opennaijR/reference/cbn.md).

- filter:

  Optional filtering condition (unquoted expression).

- cols:

  Character vector or NULL. Columns to keep. All columns if NULL.

- rename:

  Named character vector or NULL. Rename spec: c(new = "old").

- order:

  Character vector or NULL. Optional final column order.

- reason:

  Optional description of why this projection is applied.

## Value

An `opennaijR_tbl` with applied transformations and manifest.
