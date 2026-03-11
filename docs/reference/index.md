# Package index

## Data Access

Fetch official Central Bank of Nigeria (CBN) datasets directly in R.
Supports inflation, exchange rates, GDP, money supply, crude oil,
government securities, and 21 other institutional datasets. Results are
automatically cleaned, cached, and returned as analysis-ready objects
with full reproducibility metadata.

- [`nga_cbn()`](https://laws2020.github.io/opennaijR/reference/nga_cbn.md)
  : Fetch Data from the Central Bank of Nigeria (CBN)
- [`cbn()`](https://laws2020.github.io/opennaijR/reference/cbn.md) :
  Access Central Bank of Nigeria (CBN) datasets

## Data Discovery

Explore all available Nigerian and African economic datasets before
fetching. Search by keyword, filter by source institution, and inspect
available variables. Always start here if you are unsure of a dataset
name or what columns a dataset contains.

- [`discover_datasets()`](https://laws2020.github.io/opennaijR/reference/discover_datasets.md)
  : Discover Available Datasets and Variables

## Data Preparation

Shape and enrich your dataset after retrieval. Select and rename
columns, apply row filters, derive new economic indicators such as
year-on-year changes, percentage growth, or bid-ask spreads, and handle
missing values – all with a full audit trail attached to the returned
object.

- [`apply_projection()`](https://laws2020.github.io/opennaijR/reference/apply_projection.md)
  : Project, filter, and reshape an opennaijR dataset with manifest
  tracking
- [`derive_measure()`](https://laws2020.github.io/opennaijR/reference/derive_measure.md)
  : Derive new measures in an opennaijR_tbl with manifest tracking
- [`ng_fill_missing()`](https://laws2020.github.io/opennaijR/reference/ng_fill_missing.md)
  : Fill Missing Values in Datasets

## Visualisation

Plot Nigerian inflation trends and macroeconomic time series.
Automatically annotates charts with key Nigerian economic events such as
policy rate changes, currency devaluations, and oil shocks. No manual
formatting required.

- [`plot_inflation()`](https://laws2020.github.io/opennaijR/reference/plot_inflation.md)
  : Plot Nigerian Inflation Trends
- [`plot_inflation_shocks()`](https://laws2020.github.io/opennaijR/reference/plot_inflation_shocks.md)
  : Plot Inflation with Macroeconomic Shocks

## Cache Management

Inspect, list, and clear the local pins-based data cache. The cache
avoids unnecessary API calls and enables offline reproducibility. Use
these functions to manage storage or force a fresh download.

- [`naijr_cache_clear()`](https://laws2020.github.io/opennaijR/reference/naijr_cache_clear.md)
  : Clear opennaijR cache
- [`naijr_cache_info()`](https://laws2020.github.io/opennaijR/reference/naijr_cache_info.md)
  : Inspect metadata for a cached dataset
- [`naijr_cache_list()`](https://laws2020.github.io/opennaijR/reference/naijr_cache_list.md)
  : List cached opennaijR datasets
