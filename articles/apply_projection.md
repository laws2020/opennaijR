# Schema Management with apply_projection()

## What is `apply_projection()`?

When you retrieve data from the CBN API, the result contains every
column the endpoint offers — sometimes more than you need, and almost
always with names that require explanation.
[`apply_projection()`](https://laws2020.github.io/opennaijR/reference/apply_projection.md)
lets you take control of that raw data by doing three things in a
single, auditable step:

1.  **Select** — keep only the columns you care about.
2.  **Rename** — replace technical column names with human-readable
    labels.
3.  **Reorder** — arrange columns in the sequence that fits your
    workflow.

Every call is silently recorded in a **projection manifest** attached to
the result as an attribute. This means you can always look back and see
*exactly* what was done, when it was done, and why — which is essential
for reproducible research.

------------------------------------------------------------------------

## Input and Output

| Argument | Type                           | What it does                                              |
|----------|--------------------------------|-----------------------------------------------------------|
| `.data`  | `data.frame` / `opennaijR_tbl` | Your raw or previously projected dataset                  |
| `cols`   | `character vector`             | Names of the columns to keep                              |
| `rename` | **named** `character vector`   | New names mapped to old names: `c(NewName = "old_name")`  |
| `order`  | `character vector`             | Final column order (use post-rename names if you renamed) |
| `reason` | `character scalar`             | Optional label stored in the manifest for audit purposes  |

**Output:** A `data.frame` of the same class as the input, containing
only the requested columns in the requested order, with the requested
names — plus a `projection_manifest` attribute.

------------------------------------------------------------------------

## 1. Selecting Columns

The simplest use case: you only want two of the many columns in the
inflation dataset.

``` r
library(opennaijR)

infl <- cbn("inflation")

# Keep only the date and headline year-on-year figure
infl_basic <- apply_projection(
  infl,
  cols = c("date", "headline_yoy")
)

head(infl_basic)
```

**What happened?** Every column except `date` and `headline_yoy` was
dropped. The data is otherwise unchanged — same rows, same values, same
order.

To keep more columns, just extend the vector:

``` r
infl_three_cols <- apply_projection(
  infl,
  cols = c("date", "headline_yoy", "food_yoy")
)
```

------------------------------------------------------------------------

## 2. Renaming Columns

Renaming uses a **named** character vector where the *name* on the left
is what you want the column to be called, and the *value* on the right
is what it is called now.

``` r
# Rename all columns — no selection, every column is kept
infl_renamed <- apply_projection(
  infl,
  rename = c(
    Date     = "date",
    Headline = "headline_yoy",
    Food     = "food_yoy"
  )
)
```

If you only rename a subset of columns, the rest keep their original
names.

> **Common mistake:** Passing an *unnamed* vector to `rename` will throw
> an error.
>
> ``` r
> # This will fail — no names on the left-hand side
> apply_projection(infl, rename = c("headline_yoy"))
> #> Error: `rename` must be a named vector: c(new_name = 'old_name')
> ```

------------------------------------------------------------------------

## 3. Selecting and Renaming Together

You can combine `cols` and `rename` in one call. The columns not listed
in `cols` are dropped first, and then the remaining columns are renamed.

``` r
infl_clean <- apply_projection(
  infl,
  cols   = c("date", "headline_yoy", "food_yoy"),
  rename = c(
    Date     = "date",
    Headline = "headline_yoy",
    Food     = "food_yoy"
  )
)

head(infl_clean)
#>         Date Headline     Food
#> 1 2010-01-01    11.80    14.60
#> 2 2010-02-01    14.05    17.02
#> ...
```

------------------------------------------------------------------------

## 4. Reordering Columns

Use `order` when the column sequence matters — for example, a dashboard
that expects a specific layout, or a report where the most important
indicator should appear first.

``` r
# Put food before headline, even though we selected headline first
infl_reordered <- apply_projection(
  infl,
  cols  = c("date", "headline_yoy", "food_yoy"),
  order = c("food_yoy", "headline_yoy", "date")
)
```

**After renaming**, use the *new* names in `order`, not the original
ones:

``` r
infl_report <- apply_projection(
  infl,
  cols   = c("date", "headline_yoy", "food_yoy"),
  rename = c(Date = "date", Headline = "headline_yoy", Food = "food_yoy"),
  order  = c("Date", "Headline", "Food")
)
```

------------------------------------------------------------------------

## 5. Adding a Reason (Audit Trail)

The `reason` argument does not change the data at all — it adds a
human-readable label to the manifest so you can recall *why* a
particular projection was applied.

``` r
policy_brief <- apply_projection(
  infl,
  cols   = c("date", "headline_yoy", "core_ex_farm_yoy"),
  rename = c(Date = "date", Headline = "headline_yoy", Core = "core_ex_farm_yoy"),
  reason = "Quarterly macroeconomic policy brief — Q1 2025"
)
```

Inspect the manifest afterwards:

``` r
manifest <- attr(policy_brief, "projection_manifest")

manifest[[1]]$timestamp  # When it ran
manifest[[1]]$reason     # Your label
manifest[[1]]$cols_kept  # Which columns were kept
```

------------------------------------------------------------------------

## 6. Chaining Projections (Audit-Trail Accumulation)

You can call
[`apply_projection()`](https://laws2020.github.io/opennaijR/reference/apply_projection.md)
on the *result* of a previous call. Each step appends a new entry to the
manifest, giving you a complete audit trail of every transformation.

``` r
# Step 1 — select
step1 <- apply_projection(
  infl,
  cols   = c("date", "headline_yoy", "food_yoy"),
  reason = "Initial column selection"
)

# Step 2 — rename (applied to step1's output)
step2 <- apply_projection(
  step1,
  rename = c(Date = "date", Headline = "headline_yoy", Food = "food_yoy"),
  reason = "Standardize names for reporting"
)

# Both steps are recorded
attr(step2, "projection_manifest")
#> [[1]]
#> $action    "projection"
#> $reason    "Initial column selection"
#> $timestamp  ...
#>
#> [[2]]
#> $action    "projection"
#> $reason    "Standardize names for reporting"
#> $timestamp  ...
```

This is particularly useful when a dataset passes through multiple
analyst hands or pipeline stages.

------------------------------------------------------------------------

## 7. Pipe-Friendly Usage

[`apply_projection()`](https://laws2020.github.io/opennaijR/reference/apply_projection.md)
works naturally in a `|>` or `%>%` pipeline:

``` r
library(dplyr)

infl |>
  apply_projection(
    cols   = c("date", "headline_yoy", "food_yoy"),
    rename = c(Date = "date", Headline = "headline_yoy", Food = "food_yoy"),
    reason = "Pipeline transformation for dashboard"
  )
```

------------------------------------------------------------------------

## 8. Standardizing Schemas Across Datasets

One powerful use of
[`apply_projection()`](https://laws2020.github.io/opennaijR/reference/apply_projection.md)
is ensuring that different datasets share the same column naming
convention before merging or comparing them.

``` r
exchange <- cbn("exchange_rates")

# Give both datasets a common "Date" column name
infl_std <- apply_projection(
  infl,
  rename = c(Date = "date"),
  reason = "Standard schema — macro datasets"
)

exchange_std <- apply_projection(
  exchange,
  rename = c(Date = "ratedate"),
  reason = "Standard schema — macro datasets"
)

# Now both share the same "Date" column and can be merged cleanly
macro <- merge(infl_std, exchange_std, by = "Date")
```

------------------------------------------------------------------------

## 9. Error Reference

| Situation                                         | Error message                                                   |
|---------------------------------------------------|-----------------------------------------------------------------|
| Column listed in `cols` does not exist            | `Unknown column(s) in projection: <name>`                       |
| `rename` vector has no names                      | `` `rename` must be a named vector: c(new_name = 'old_name') `` |
| Column listed in `order` not in the projected set | Error naming the missing column                                 |

------------------------------------------------------------------------

## Workflow Position

[`apply_projection()`](https://laws2020.github.io/opennaijR/reference/apply_projection.md)
is the **first transformation** you apply after
[`cbn()`](https://laws2020.github.io/opennaijR/reference/cbn.md). Think
of it as setting your schema before any calculations begin. The typical
opennaijR workflow looks like this:

    cbn()  →  apply_projection()  →  derive_measure()  →  analysis

Once you have a clean, consistently named dataset, you are ready to
engineer features with
[`derive_measure()`](https://laws2020.github.io/opennaijR/reference/derive_measure.md).
