# Derive new measures in an opennaijR_tbl with manifest tracking

`derive_measure()` calculates new variables from existing data, such as
YoY, MoM, rebased, or percentage changes.

## Usage

``` r
derive_measure(.data, ..., reason = NULL)
```

## Arguments

- .data:

  An `opennaijR_tbl` object

- ...:

  Named expressions for new measures

- reason:

  Optional description of why these measures are derived

## Value

An `opennaijR_tbl`

## Examples

``` r
if (FALSE) { # \dontrun{
# Retrieve CBN inflation dataset
infl <- cbn("inflation")   # returns opennaijR_tbl

# 1. Derive difference between headline and food inflation
infl_diff <- derive_measure(
  infl,
  gap_headline_food = headline_yoy - food_yoy
)

# 2. Derive percentage contribution of food inflation
infl_pct <- derive_measure(
  infl,
  food_share = (food_yoy / headline_yoy) * 100
)

# 3. Compute month-to-month change of headline YoY
infl_mom_change <- derive_measure(
  infl,
  headline_yoy_change = headline_yoy - lag(headline_yoy)
)

# 4. Chain multiple derived measures
infl_chain <- derive_measure(
  infl,
  gap = headline_yoy - core_ex_farm_yoy,
  energy_gap = core_ex_farm_energy_yoy - core_ex_farm_yoy,
  reason = "Compare structural inflation components"
)

# 5. Inspect derivation manifest
attr(infl_chain, "derive_manifest")
} # }
```
