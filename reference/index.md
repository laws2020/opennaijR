# Package index

## Data Access

Fetch and automatically clean official CBN data. These functions connect
directly to institutional endpoints, handle caching, and return
analysis-ready objects.

- [`nga_cbn()`](https://laws2020.github.io/opennaijR/reference/nga_cbn.md)
  : Fetch Data from the Central Bank of Nigeria (CBN)
- [`cbn()`](https://laws2020.github.io/opennaijR/reference/cbn.md) :
  Access Central Bank of Nigeria (CBN) datasets

## Data Discovery

Explore what datasets and indicators are available before fetching.
Always start here if you are unsure of a dataset name.

- [`discover_datasets()`](https://laws2020.github.io/opennaijR/reference/discover_datasets.md)
  : Discover Available Datasets and Variables

## Data Preparation

Clean, reshape, and augment your dataset after retrieval. Use these
functions to select columns, rename variables, derive new indicators,
and handle missing values.

- [`apply_projection()`](https://laws2020.github.io/opennaijR/reference/apply_projection.md)
  : Project, filter, and reshape an opennaijR dataset with manifest
  tracking
- [`derive_measure()`](https://laws2020.github.io/opennaijR/reference/derive_measure.md)
  : Derive new measures in an opennaijR_tbl with manifest tracking
- [`ng_fill_missing()`](https://laws2020.github.io/opennaijR/reference/ng_fill_missing.md)
  : Fill Missing Values in Datasets

## Visualisation

Plot inflation trends and macroeconomic indicators. These functions
produce ready-to-use charts with no manual formatting required.

- [`plot_inflation()`](https://laws2020.github.io/opennaijR/reference/plot_inflation.md)
  : Plot Nigerian Inflation Trends
- [`plot_inflation_shocks()`](https://laws2020.github.io/opennaijR/reference/plot_inflation_shocks.md)
  : Plot Inflation with Macroeconomic Shocks

## Cache Management

Manage local data storage to improve performance.

- [`naijr_cache_clear()`](https://laws2020.github.io/opennaijR/reference/naijr_cache_clear.md)
  : Clear opennaijR cache
- [`naijr_cache_info()`](https://laws2020.github.io/opennaijR/reference/naijr_cache_info.md)
  : Inspect metadata for a cached dataset
- [`naijr_cache_list()`](https://laws2020.github.io/opennaijR/reference/naijr_cache_list.md)
  : List cached opennaijR datasets
