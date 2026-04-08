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

    ## # A tibble: 21 × 5
    ##    dataset_key                dataset_id               source aliases  variables
    ##    <chr>                      <chr>                    <chr>  <chr>    <chr>    
    ##  1 inflation_ng               cbn_inflation            CBN    inflati… headline…
    ##  2 exchange_rates             cbn_exchange_rates       CBN    exchang… buying_r…
    ##  3 nfem_exchange_rates        cbn_nfem_rates           CBN    nfem, n… closing,…
    ##  4 monthly_avg_exchange_rates cbn_monthly_avg_exchange CBN    monthly… ifem_dol…
    ##  5 crude_oil                  cbn_crude_oil            CBN    crude o… price_bo…
    ##  6 daily_crude_oil            cbn_daily_crude_oil      CBN    daily c… price_bo…
    ##  7 external_reserves          cbn_external_reserves    CBN    externa… gross_re…
    ##  8 money_credit               cbn_money_credit         CBN    money a… broad_mo…
    ##  9 money_market               cbn_money_market         CBN    money m… interban…
    ## 10 interbank_rates            cbn_interbank_rates      CBN    interba… rate_typ…
    ## # ℹ 11 more rows

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

    ## Fetching raw data from 'https://www.cbn.gov.ng/api/GetAllExchangeRates' ...

    ## Applying canonicalization using 'standardize_cbn_exchange'

    ## Creating new version '20260408T055010Z-78dd8'
    ## Writing to pin 'cbn__exchange_rates__d305a3e522e5ccc56286e414cfd231cd'

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
    ## Rows: 60683  Columns: 5 
    ## 
    ##              currency buying_rate central_rate selling_rate       date
    ## 1                 CFA      2.4093       2.4193       2.4293 2026-04-07
    ## 2       YUAN/RENMINBI    202.0468     202.1197     202.1926 2026-04-07
    ## 3        DANISH KRONA    214.6742     214.7516     214.8291 2026-04-07
    ## 4                EURO   1604.4526    1605.0315    1605.6105 2026-04-07
    ## 5                 YEN      8.6690       8.6722       8.6753 2026-04-07
    ## 6               RIYAL    368.9871     369.1203     369.2534 2026-04-07
    ## 7  SOUTH AFRICAN RAND     82.1135      82.1431      82.1728 2026-04-07
    ## 8                 SDR   1885.7410    1886.4215    1887.1019 2026-04-07
    ## 9         SWISS FRANC   1732.9381    1733.5634    1734.1887 2026-04-07
    ## 10    POUNDS STERLING   1837.2430    1837.9060    1838.5689 2026-04-07

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

    ## Fetching raw data from 'https://www.cbn.gov.ng/api/GetAllExchangeRates' ...

    ## Applying canonicalization using 'standardize_cbn_exchange'

    ## Creating new version '20260408T055011Z-8cf21'
    ## Writing to pin 'cbn__exchange_rates__3be8261f4f13056b9a63ec5304c99646'

    ## <opennaijR table>
    ## Rows: 60683  Columns: 2 
    ## 
    ##              currency buying_rate
    ## 1                 CFA      2.4093
    ## 2       YUAN/RENMINBI    202.0468
    ## 3        DANISH KRONA    214.6742
    ## 4                EURO   1604.4526
    ## 5                 YEN      8.6690
    ## 6               RIYAL    368.9871
    ## 7  SOUTH AFRICAN RAND     82.1135
    ## 8                 SDR   1885.7410
    ## 9         SWISS FRANC   1732.9381
    ## 10    POUNDS STERLING   1837.2430

#### Select a date range:

``` r
cbn("exchange_rates", from = "2020-01-01", to = "2023-12-31")
```

    ## Fetching raw data from 'https://www.cbn.gov.ng/api/GetAllExchangeRates' ...

    ## Applying canonicalization using 'standardize_cbn_exchange'

    ## Creating new version '20260408T055013Z-78dd8'
    ## Writing to pin 'cbn__exchange_rates__2e6bdf4cdb0fbe97c9a08bf8ce123481'

    ## <opennaijR table>
    ## Rows: 60683  Columns: 5 
    ## 
    ##              currency buying_rate central_rate selling_rate       date
    ## 1                 CFA      2.4093       2.4193       2.4293 2026-04-07
    ## 2       YUAN/RENMINBI    202.0468     202.1197     202.1926 2026-04-07
    ## 3        DANISH KRONA    214.6742     214.7516     214.8291 2026-04-07
    ## 4                EURO   1604.4526    1605.0315    1605.6105 2026-04-07
    ## 5                 YEN      8.6690       8.6722       8.6753 2026-04-07
    ## 6               RIYAL    368.9871     369.1203     369.2534 2026-04-07
    ## 7  SOUTH AFRICAN RAND     82.1135      82.1431      82.1728 2026-04-07
    ## 8                 SDR   1885.7410    1886.4215    1887.1019 2026-04-07
    ## 9         SWISS FRANC   1732.9381    1733.5634    1734.1887 2026-04-07
    ## 10    POUNDS STERLING   1837.2430    1837.9060    1838.5689 2026-04-07

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
    ## 11 2026-04-07 US DOLLAR 1385.657 1386.157 1386.657
    ## 24 2026-04-02 US DOLLAR 1379.794 1380.294 1380.794
    ## 37 2026-04-01 US DOLLAR 1377.701 1378.201 1378.701
    ## 50 2026-03-31 US DOLLAR 1385.716 1386.216 1386.716
    ## 63 2026-03-30 US DOLLAR 1382.581 1383.081 1383.581
    ## 76 2026-03-27 US DOLLAR 1379.577 1380.077 1380.577

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
    ## [1] "2026-04-08 05:50:13 UTC"
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
    ## 11 2026-04-07 US DOLLAR 1385.657 1386.157 1386.657          0
    ## 24 2026-04-02 US DOLLAR 1379.794 1380.294 1380.794          0
    ## 37 2026-04-01 US DOLLAR 1377.701 1378.201 1378.701          0
    ## 50 2026-03-31 US DOLLAR 1385.716 1386.216 1386.716          0
    ## 63 2026-03-30 US DOLLAR 1382.581 1383.081 1383.581          0
    ## 76 2026-03-27 US DOLLAR 1379.577 1380.077 1380.577          0

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
    ## [1] "2026-04-08 05:50:13 UTC"
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
