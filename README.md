
<div style="height: 45px;">

</div>

# opennaijR <img src="man/figures/opennaijR_logo.png" align="right" width="180" alt="opennaijR logo"/>

***opennaijR*** simplifies access to Nigerian open data from the CBN,
NBS, NGX, and other sources. It automates the cleaning of official
datasets, turning hours of manual work into seconds of analysis-ready
results. It is a reproducible macroeconomic data engineering for
Nigeria. Use `discover_datasets()` to find your variable of interest,
then pass it to `cbn()` to start downloading.

## Workflow

The typical workflow is three steps:

    discover_datasets()  -->  cbn()  -->  analyse

## Installation

``` r
#Install released version from GitHub using remotes:
install.packages("remotes")
remotes::install_github("laws2020/opennaijR")
```

## Usage

### Search for available datasets

Before pulling data with `cbn()`, you need to know what is available.
Use `discover_datasets()`, it is the entry point to opennaijR. Users
should **never guess dataset names**.

It returns:

- available datasets exist  
- their source (CBN, WB, NBS, etc.)  
- available indicators

``` r
discover_datasets()|> print(n = 6)
```

    ## # A tibble: 23 × 5
    ##   dataset_key     dataset_id          source aliases                   variables
    ##   <chr>           <chr>               <chr>  <chr>                     <chr>    
    ## 1 crude_oil       cbn_crude_oil       CBN    crude oil, oil price, bo… price_bo…
    ## 2 daily_crude_oil cbn_daily_crude_oil CBN    daily crude oil, daily o… price_bo…
    ## 3 discount_rates  cbn_discount_rates  CBN    discount rates, discount… discount…
    ## 4 ntb_cbn         cbn_ntb             CBN    ntb, nigeria treasury bi… total_su…
    ## 5 fgn_bond        cbn_fgn_bond        CBN    fgn bond, fgn bonds, nig… total_su…
    ## 6 omo             cbn_omo             CBN    omo, open market operati… total_su…
    ## # ℹ 17 more rows

Alternative: print everything:

``` r
discover_datasets() |> print(n = Inf)
```

### Download the Data

Once you have found a dataset name using `discover_datasets()`, pass it
to `cbn()` to download the data into your R session. You can use either
the dataset_key or an alias. For example, to retrieve official inflation
data from the Central Bank of Nigeria using the “inflation” alias:

``` r
# Fetch data (cached internally by opennaijR after the first run)
infl <- cbn("inflation")
```

### View the records

``` r
head(infl[, c("date", "headline_yoy", "food_yoy", "core_ex_farm_yoy")])
```

    ## <opennaijR table>
    ## Rows: 6  Columns: 4 
    ## 
    ##         date headline_yoy food_yoy core_ex_farm_yoy
    ## 1 2026-01-01        15.10     8.89            17.18
    ## 2 2025-12-01        15.15    10.84            18.16
    ## 3 2025-11-01        17.33    14.21            19.84
    ## 4 2025-10-01        18.97    16.30            20.61
    ## 5 2025-09-01        20.98    20.16            21.61
    ## 6 2025-08-01        23.14    25.30            22.63

That’s it. `infl` is now a clean, tidy data frame ready for analysis—no
manual cleaning required.

Under the hood, `cbn()` connects to the official CBN data stream,
normalises column names, parses dates into proper R Date objects, and
returns a structure compatible with ggplot2 and dplyr.

infl is ready for lm(), ggplot2, dplyr, or any other tool you reach for.
The next sections show the opennaijR-specific functions that make your
workflow more precise and reproducible.

### Cache Management

Data is fetched from the web once, then stored locally for near-instant
loading in future sessions.

``` r
# First run: Downloads from CBN | Subequent runs: Loads from local disk
cbn("inflation")[, c("date", "headline_yoy", "food_yoy", "core_ex_farm_yoy")]
```

    ## 📦 Loading cached CBN data from pins

    ## <opennaijR table>
    ## Rows: 277  Columns: 4 
    ## 
    ##          date headline_yoy food_yoy core_ex_farm_yoy
    ## 1  2026-01-01        15.10     8.89            17.18
    ## 2  2025-12-01        15.15    10.84            18.16
    ## 3  2025-11-01        17.33    14.21            19.84
    ## 4  2025-10-01        18.97    16.30            20.61
    ## 5  2025-09-01        20.98    20.16            21.61
    ## 6  2025-08-01        23.14    25.30            22.63
    ## 7  2025-07-01        24.94    26.20            23.93
    ## 8  2025-06-01        26.06    24.55            25.88
    ## 9  2025-05-01        26.06    24.55            25.88
    ## 10 2025-04-01        26.82    24.68            27.12

### Take Control

Manage your local cache with the naijr_cache\_\* family:

``` r
#Use code with caution.
naijr_cache_clear("inflation") #Force a fresh download by wiping specific datasets.

naijr_cache_list() #See every dataset currently stored on your machine.

naijr_cache_info() #Check cache size and file locations.
```

## Schema Control — `apply_projection()`

`cbn()` returns all available columns. `apply_projection()` lets you
select, rename, and reorder them in a single auditable call.

``` r
infl <- cbn("inflation")

proj <- apply_projection(
  infl,
  cols   = c("date", "headline_yoy", "food_yoy", "core_ex_farm_yoy"),
  rename = c(
    headline = "headline_yoy",
    food     = "food_yoy",
    core     = "core_ex_farm_yoy"
  ),
  order  = c("date", "headline", "food", "core"),
  reason = "Key inflation measures with clean names"
)

head(proj)
```

    ## <opennaijR table>
    ## Rows: 6  Columns: 4 
    ## 
    ##         date headline  food  core
    ## 1 2026-01-01    15.10  8.89 17.18
    ## 2 2025-12-01    15.15 10.84 18.16
    ## 3 2025-11-01    17.33 14.21 19.84
    ## 4 2025-10-01    18.97 16.30 20.61
    ## 5 2025-09-01    20.98 20.16 21.61
    ## 6 2025-08-01    23.14 25.30 22.63

Every call leaves a **projection manifest** — a built-in record of what
changed and why:

``` r
attr(proj, "projection_manifest")
```

    ## [[1]]
    ## [[1]]$timestamp
    ## [1] "2026-03-02 05:06:38 WAT"
    ## 
    ## [[1]]$action
    ## [1] "apply_projection"
    ## 
    ## [[1]]$filter
    ## NULL
    ## 
    ## [[1]]$kept
    ## [1] "date"             "headline_yoy"     "food_yoy"         "core_ex_farm_yoy"
    ## 
    ## [[1]]$renamed
    ##           headline               food               core 
    ##     "headline_yoy"         "food_yoy" "core_ex_farm_yoy" 
    ## 
    ## [[1]]$ordered
    ## [1] "date"     "headline" "food"     "core"    
    ## 
    ## [[1]]$reason
    ## [1] "Key inflation measures with clean names"

The manifest records the timestamp, which columns were kept, how they
were renamed, and the reason you supplied. This makes your workflow
reproducible by design.

------------------------------------------------------------------------

## Feature Engineering — `derive_measure()`

Create new analytical columns directly from your dataset. Reference
column names as bare expressions — no `$` or `[[]]` needed.

``` r
infl_features <- derive_measure(
  infl,
  gap          = headline_yoy - food_yoy,
  accelerating = headline_yoy > lag(headline_yoy),
  high_regime  = headline_yoy > 15,
  reason       = "Inflation diagnostic indicators"
)

head(infl_features)[, c("date", "gap", "accelerating","high_regime" )]
```

    ## <opennaijR table>
    ## Rows: 6  Columns: 4 
    ## 
    ##         date   gap accelerating high_regime
    ## 1 2026-01-01  6.21        FALSE        TRUE
    ## 2 2025-12-01  4.31        FALSE        TRUE
    ## 3 2025-11-01  3.12        FALSE        TRUE
    ## 4 2025-10-01  2.67        FALSE        TRUE
    ## 5 2025-09-01  0.82        FALSE        TRUE
    ## 6 2025-08-01 -2.16        FALSE        TRUE

Like projections, every derivation is tracked:

``` r
attr(infl_features, "derive_manifest")
```

    ## [[1]]
    ## [[1]]$timestamp
    ## [1] "2026-03-02 05:06:38 WAT"
    ## 
    ## [[1]]$action
    ## [1] "derive_measure"
    ## 
    ## [[1]]$derived
    ## [1] "gap"          "accelerating" "high_regime" 
    ## 
    ## [[1]]$expressions
    ##                                 gap                        accelerating 
    ##          "~headline_yoy - food_yoy" "~headline_yoy > lag(headline_yoy)" 
    ##                         high_regime 
    ##                "~headline_yoy > 15" 
    ## 
    ## [[1]]$reason
    ## [1] "Inflation diagnostic indicators"

The manifest stores the exact expressions evaluated, the timestamp, and
your declared intent. You can chain multiple `derive_measure()` calls
and the record accumulates step by step — giving you a full audit trail
from raw data to final feature set.

------------------------------------------------------------------------

## A Complete Workflow

``` r
library(opennaijR)

# 1. Find and fetch
infl <- cbn("inflation")

# 2. Clean schema
infl_clean <- apply_projection(
  infl,
  cols   = c("date", "headline_yoy", "food_yoy", "core_ex_farm_yoy"),
  rename = c(Date = "date", Headline = "headline_yoy",
             Food = "food_yoy", Core = "core_ex_farm_yoy"),
  reason = "Baseline schema for analysis"
)

# 3. Engineer features
infl_ready <- derive_measure(
  infl_clean,
  gap         = Headline - Food,
  accelerating = Headline > lag(Headline),
  high_regime  = Headline > 15,
  reason       = "Diagnostic indicators"
)

# 4. Model
lm(Headline ~ Food + Core, data = infl_ready) |> summary()
```

## Learn More

Full documentation and worked examples are available in the package
articles:

- **Schema Management** — a complete guide to `apply_projection()`
- **Feature Engineering** — every class of derivation with
  `derive_measure()`
- **Macro Regime & Regression Analysis** — a full research pipeline from
  raw data to econometric models
