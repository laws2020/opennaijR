# Bind source metadata to a validated query (internal)

`bind_source()` validates a parsed query against the official manifest
registry and attaches the corresponding dataset metadata.

This function:

- Normalizes the source and dataset identifiers

- Verifies that the source exists in
  [`.manifest_registry()`](https://laws2020.github.io/opennaijR/reference/dot-manifest_registry.md)

- Confirms that the dataset is defined for that source

- Attaches the dataset-level manifest to the query object

It acts as a strict validation layer to ensure that only officially
registered data authorities and datasets are allowed in the pipeline.

## Usage

``` r
bind_source(query)
```

## Arguments

- query:

  A structured query object containing at least:

  - `query$intent$source`

  - `query$intent$dataset`

## Value

The modified query object with a `manifest` element attached.
