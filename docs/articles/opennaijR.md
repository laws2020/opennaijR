# Introduction to opennaijR

***opennaijR*** is a reproducible macroeconomic data engineering
framework for Africa. It gives you direct programmatic access to
official economic data from central banks and national statistics
bureaus – starting with Nigeria and expanding continent-wide. You ask
for a dataset by name. opennaijR connects to the source, cleans the
result, and returns a tidy, analysis-ready object. Every transformation
is recorded so your work is fully reproducible from the moment data
enters your workflow.

## Getting Started

`opennaijR` helps you access Nigerian public data (like inflation,
exchange rates, GDP, etc.) in just **three simple steps**:

1.  **Load OpennaijR Package**
2.  **Discover what datasets are available**
3.  **Fetch the dataset you need**

Let’s walk through this step-by-step.

### Step 1: Load the Package

Before doing anything, load the package:

``` r
library(opennaijR)
```

That makes all `opennaijR functions` available in your R session.

## Step 2: Discover Available Datasets

Think of
[`discover_datasets()`](https://laws2020.github.io/opennaijR/reference/discover_datasets.md)
as a **catalog of datasets**.

[`discover_datasets()`](https://laws2020.github.io/opennaijR/reference/discover_datasets.md)
shows you what Nigerian datasets are available and where they come from
— so you can decide what to analyze next. Just like browsing a store
before buying something, this function shows you:

- Dataset names
- Dataset IDs
- Data source (e.g., CBN)
- Alternative names (aliases)
- Available variables (columns you can request)

Run:

``` r
discover_datasets()
```

    ## # A tibble: 23 × 5
    ##    dataset_key                dataset_id               source aliases  variables
    ##    <chr>                      <chr>                    <chr>  <chr>    <chr>    
    ##  1 crude_oil                  cbn_crude_oil            CBN    crude o… price_bo…
    ##  2 daily_crude_oil            cbn_daily_crude_oil      CBN    daily c… price_bo…
    ##  3 discount_rates             cbn_discount_rates       CBN    discoun… discount…
    ##  4 ntb_cbn                    cbn_ntb                  CBN    ntb, ni… total_su…
    ##  5 fgn_bond                   cbn_fgn_bond             CBN    fgn bon… total_su…
    ##  6 omo                        cbn_omo                  CBN    omo, op… total_su…
    ##  7 cbn_sec                    cbn_securities           CBN    cbn sec… total_su…
    ##  8 exchange_rates             cbn_exchange_rates       CBN    exchang… buying_r…
    ##  9 nfem_exchange_rates        cbn_nfem_rates           CBN    nfem, n… closing,…
    ## 10 monthly_avg_exchange_rates cbn_monthly_avg_exchange CBN    monthly… ifem_dol…
    ## # ℹ 13 more rows

To see the full list in R console use ’discover_datasets() \|\> print(n
= Inf)\`

#### What You’ll See

A clean table with columns like:

| dataset_key | dataset_id | source | aliases | variables |
|-------------|------------|--------|---------|-----------|

#### Why This Is Important

Instead of guessing dataset names, you can:

- See what datasets exist
- Search by keyword
- Check what variables are available

#### Search for a Specific Dataset

If you’re looking for exchange rate data:

``` r
discover_datasets(dataset = "exchange")
```

    ## # A tibble: 3 × 5
    ##   dataset_key                dataset_id               source aliases   variables
    ##   <chr>                      <chr>                    <chr>  <chr>     <chr>    
    ## 1 exchange_rates             cbn_exchange_rates       CBN    exchange… buying_r…
    ## 2 nfem_exchange_rates        cbn_nfem_rates           CBN    nfem, nf… closing,…
    ## 3 monthly_avg_exchange_rates cbn_monthly_avg_exchange CBN    monthly … ifem_dol…

This filters the catalog to only datasets that match “exchange”.

##### Search Within a Specific Source

If you want to narrow your search to a particular data source (like
CBN), you can combine source and dataset.

For example, to find inflation datasets from CBN only:

``` r
discover_datasets(source = "cbn", dataset = "inflation")
```

    ## # A tibble: 1 × 5
    ##   dataset_key  dataset_id    source aliases                    variables        
    ##   <chr>        <chr>         <chr>  <chr>                      <chr>            
    ## 1 inflation_ng cbn_inflation CBN    inflation, inflation rates headline_yoy, he…

This tells opennaijR:

Look only inside the CBN source

Return datasets that match “inflation”

##### Why This Is Useful

Instead of scrolling through everything, you can:

Search by keyword

Limit by source

Quickly discover the exact dataset you need

Think of it like using filters on an online store:

dataset = “inflation” → Search bar

source = “cbn” → Store category filter

## Step 3: Fetch Data

Once you know the dataset name, fetching data is very simple.

To get exchange rates from the Central Bank of Nigeria (CBN):

``` r
exchange_rates <- cbn("exchange_rates")
```

    ## 📦 Loading cached CBN data from pins

That’s it.

You now have the data stored in:

`exchange_rates`

### What Happens Behind the Scenes?

When you run:

``` r
cbn("exchange_rates")
```

    ## 📦 Loading cached CBN data from pins

    ## <opennaijR table>
    ## Rows: 60449  Columns: 5 
    ## 
    ##              currency buying_rate central_rate selling_rate       date
    ## 1                 CFA      2.4365       2.4465       2.4565 2026-03-06
    ## 2       YUAN/RENMINBI    201.5717     201.6441     201.7165 2026-03-06
    ## 3        DANISH KRONA    215.4961     215.5735     215.6509 2026-03-06
    ## 4                EURO   1610.2828    1610.8611    1611.4394 2026-03-06
    ## 5                 YEN      8.8168       8.8199       8.8231 2026-03-06
    ## 6               RIYAL    370.9318     371.0651     371.1983 2026-03-06
    ## 7  SOUTH AFRICAN RAND     83.4325      83.4625      83.4925 2026-03-06
    ## 8                 SDR   1900.2897    1900.9721    1901.6546 2026-03-06
    ## 9         SWISS FRANC   1779.6953    1780.3344    1780.9735 2026-03-06
    ## 10    POUNDS STERLING   1858.6612    1859.3287    1859.9962 2026-03-06

opennaijR automatically:

1.  Builds a data request
2.  Checks if you already downloaded it before (cache system)
3.  Downloads fresh data if needed
4.  Cleans and standardizes the data
5.  Saves it for faster reuse next time

So next time you run the same request, it loads instantly.

You don’t need to manage any of this manually.

### Optional: Filter Your Data

You can refine your request.

#### Select specific variables:

``` r
cbn("exchange_rates", variables = c("currency", "buying_rate"))
```

    ## 📦 Loading cached CBN data from pins

    ## <opennaijR table>
    ## Rows: 60449  Columns: 2 
    ## 
    ##              currency buying_rate
    ## 1                 CFA      2.4365
    ## 2       YUAN/RENMINBI    201.5717
    ## 3        DANISH KRONA    215.4961
    ## 4                EURO   1610.2828
    ## 5                 YEN      8.8168
    ## 6               RIYAL    370.9318
    ## 7  SOUTH AFRICAN RAND     83.4325
    ## 8                 SDR   1900.2897
    ## 9         SWISS FRANC   1779.6953
    ## 10    POUNDS STERLING   1858.6612

#### Select a date range:

``` r
cbn("exchange_rates", from = "2020-01-01", to = "2023-12-31")
```

    ## 📦 Loading cached CBN data from pins

    ## <opennaijR table>
    ## Rows: 60449  Columns: 5 
    ## 
    ##              currency buying_rate central_rate selling_rate       date
    ## 1                 CFA      2.4365       2.4465       2.4565 2026-03-06
    ## 2       YUAN/RENMINBI    201.5717     201.6441     201.7165 2026-03-06
    ## 3        DANISH KRONA    215.4961     215.5735     215.6509 2026-03-06
    ## 4                EURO   1610.2828    1610.8611    1611.4394 2026-03-06
    ## 5                 YEN      8.8168       8.8199       8.8231 2026-03-06
    ## 6               RIYAL    370.9318     371.0651     371.1983 2026-03-06
    ## 7  SOUTH AFRICAN RAND     83.4325      83.4625      83.4925 2026-03-06
    ## 8                 SDR   1900.2897    1900.9721    1901.6546 2026-03-06
    ## 9         SWISS FRANC   1779.6953    1780.3344    1780.9735 2026-03-06
    ## 10    POUNDS STERLING   1858.6612    1859.3287    1859.9962 2026-03-06

### Summary

| Task                   | Function                                 |
|------------------------|------------------------------------------|
| See available datasets | `discover_manifest()`                    |
| Search for a dataset   | `discover_manifest(dataset = "keyword")` |
| Fetch CBN data         | `cbn("dataset_name")`                    |
| Filter by date         | `from`, `to`                             |
| Select columns         | `variables`                              |

### Mental Model

Think of opennaijR like this:

- [`discover_datasets()`](https://laws2020.github.io/opennaijR/reference/discover_datasets.md)
  → **Browse the data catalog**
- [`cbn()`](https://laws2020.github.io/opennaijR/reference/cbn.md) “192”
  **Download the dataset you want**

Simple. Clean. Nigerian data made accessible.

## Filter and Project Data (Clean and Focus)

After fetching a dataset, it often contains:

- Many rows
- Many columns

But most times, you don’t need everything.

You may want to:

- Filter to specific rows (e.g., only USD)
- Keep only certain columns
- Rename them to something cleaner
- Reorder them for reporting
- Document why you did this

That’s what
[`apply_projection()`](https://laws2020.github.io/opennaijR/reference/apply_projection.md)
is for.

Think of it as:

> Filtering and reshaping your dataset for your specific task.

### Example: Focus Only on US Dollar Exchange Rates

First, suppose we already fetched exchange rates:

``` r
exchange_rates <- cbn("exchange_rates")
```

    ## 📦 Loading cached CBN data from pins

Now we will:

- Keep only **US Dollar**
- Select important columns
- Rename them
- Reorder them
- Record our reason

All in one step:

``` r
usd_rates <- apply_projection(
  exchange_rates,
  filter = currency == "US DOLLAR",
  cols   = c("date", "currency", "buying_rate", "central_rate", "selling_rate"),
  rename = c(
    buying  = "buying_rate",
    central = "central_rate",
    selling = "selling_rate"
  ),
  order  = c("date", "currency", "buying", "central", "selling"),
  reason = "Focus on USD rates"
)
```

#### What Just Happened?

Let’s break it down in simple terms:

| Argument | What It Does                             |
|----------|------------------------------------------|
| `filter` | Keeps only rows matching a condition     |
| `cols`   | Keeps only selected columns              |
| `rename` | Gives columns cleaner names              |
| `order`  | Rearranges column order                  |
| `reason` | Records why you made this transformation |

So instead of technical column names like:

    ratedate
    buying_rate
    central_rate

You now have clean, readable names:

    date
    buying
    central
    selling

### View the Result

``` r
head(usd_rates)
```

    ## <opennaijR table>
    ## Rows: 6  Columns: 5 
    ## 
    ##          date  currency   buying  central  selling
    ## 11 2026-03-06 US DOLLAR 1392.256 1392.756 1393.256
    ## 24 2026-03-05 US DOLLAR 1386.447 1386.947 1387.447
    ## 37 2026-03-04 US DOLLAR 1386.095 1386.595 1387.095
    ## 50 2026-03-03 US DOLLAR 1383.292 1383.792 1384.292
    ## 63 2026-03-02 US DOLLAR 1377.025 1377.525 1378.025
    ## 75 2026-02-27 US DOLLAR 1362.395 1362.895 1363.395

Now your dataset is:

- Focused (USD only)
- Clean
- Easy to read
- Ready for plotting or reporting

------------------------------------------------------------------------

#### Why `apply_projection()` Is Special

Unlike normal filtering or column selection, this function:

cat(“705 Done!”) Keeps the `opennaijR_tbl` class cat(“705 Done!”) Tracks
what you changed cat(“705 Done!”) Saves a transformation history

You can inspect the history:

``` r
attr(usd_rates, "projection_manifest")
```

    ## [[1]]
    ## [[1]]$timestamp
    ## [1] "2026-03-11 10:18:27 WAT"
    ## 
    ## [[1]]$action
    ## [1] "apply_projection"
    ## 
    ## [[1]]$filter
    ## [1] "~currency == \"US DOLLAR\""
    ## 
    ## [[1]]$kept
    ## [1] "date"         "currency"     "buying_rate"  "central_rate" "selling_rate"
    ## 
    ## [[1]]$renamed
    ##         buying        central        selling 
    ##  "buying_rate" "central_rate" "selling_rate" 
    ## 
    ## [[1]]$ordered
    ## [1] "date"     "currency" "buying"   "central"  "selling" 
    ## 
    ## [[1]]$reason
    ## [1] "Focus on USD rates"

This shows:

- When the transformation happened
- What filter was applied
- What columns were kept
- What was renamed
- The reason you provided

That makes your analysis **transparent and reproducible**.

### Derive a New Measure (Create Insight)

After filtering and cleaning your data, the next step is often to create
**new variables**.

For example:

- Year-on-year change
- Month-to-month change
- Percentage growth
- Gaps between variables
- Ratios

That’s what
[`derive_measure()`](https://laws2020.github.io/opennaijR/reference/derive_measure.md)
is for.

Think of it as:

> Creating new economic indicators from existing data.

### Example: Compute Percentage Change in USD Rates

Suppose we already prepared our dataset:

`usd_rates`

Now we want to compute the **percentage change** in exchange rates.

We can do:

``` r
usd_change <- derive_measure(
  usd_rates,
  pct_change = (buying - lag(buying)) / lag(buying) * 100,
  reason = "Compute daily percentage change in USD buying rate"
)
```

head(usd_rates)

### What Just Happened?

Let’s break it down:

| Component          | What It Does                |
|--------------------|-----------------------------|
| `pct_change = ...` | Creates a new column        |
| `lag(buying)`      | Uses previous value         |
| `* 100`            | Converts to percentage      |
| `reason`           | Documents why we created it |

So now your dataset contains a new column:

`pct_change`

That tells you how much the USD rate changed compared to the previous
period.

### View the Result

``` r
head(usd_change)
```

    ## <opennaijR table>
    ## Rows: 6  Columns: 6 
    ## 
    ##          date  currency   buying  central  selling pct_change
    ## 11 2026-03-06 US DOLLAR 1392.256 1392.756 1393.256          0
    ## 24 2026-03-05 US DOLLAR 1386.447 1386.947 1387.447          0
    ## 37 2026-03-04 US DOLLAR 1386.095 1386.595 1387.095          0
    ## 50 2026-03-03 US DOLLAR 1383.292 1383.792 1384.292          0
    ## 63 2026-03-02 US DOLLAR 1377.025 1377.525 1378.025          0
    ## 75 2026-02-27 US DOLLAR 1362.395 1362.895 1363.395          0

You now have:

- Original exchange rate columns
- A new derived column (`pct_change`)
- A recorded derivation history

##### Why `derive_measure()` Is Special

Unlike just writing:

`usd_rates$pct_change <- ...`

[`derive_measure()`](https://laws2020.github.io/opennaijR/reference/derive_measure.md):

cat(“705 Done!”) Keeps the `opennaijR_tbl` class cat(“705 Done!”) racks
the expression used cat(“705 Done!”) Records when it was created
cat(“705 Done!”) Stores your reason

You can inspect the derivation history:

``` r
attr(usd_change, "derive_manifest")
```

    ## [[1]]
    ## [[1]]$timestamp
    ## [1] "2026-03-11 10:18:27 WAT"
    ## 
    ## [[1]]$action
    ## [1] "derive_measure"
    ## 
    ## [[1]]$derived
    ## [1] "pct_change"
    ## 
    ## [[1]]$expressions
    ##                                  pct_change 
    ## "~(buying - lag(buying))/lag(buying) * 100" 
    ## 
    ## [[1]]$reason
    ## [1] "Compute daily percentage change in USD buying rate"

This makes your analysis:

- Transparent
- Reproducible
- Auditable

Very important for economic research.

### You Can Derive Multiple Measures at Once

``` r
usd_extended <- derive_measure(
  usd_rates,
  pct_change = (buying - lag(buying)) / lag(buying) * 100,
  spread = selling - buying,
  reason = "Analyze volatility and bid-ask spread"
)
```

Now you created:

- Percentage change
- Bid-ask spread

In one clean step.

### Mental Model

Your workflow now becomes:

[`discover_datasets()`](https://laws2020.github.io/opennaijR/reference/discover_datasets.md)
→ [`cbn()`](https://laws2020.github.io/opennaijR/reference/cbn.md) →
[`apply_projection()`](https://laws2020.github.io/opennaijR/reference/apply_projection.md)
→
[`derive_measure()`](https://laws2020.github.io/opennaijR/reference/derive_measure.md)
