## ----setup, include=FALSE-----------------------------------------------------
knitr::opts_chunk$set(
  collapse  = TRUE,
  comment   = "#>",
  eval      = FALSE
)

## -----------------------------------------------------------------------------
#  library(opennaijR)
#  
#  infl <- cbn("inflation")
#  
#  # Keep only the date and headline year-on-year figure
#  infl_basic <- apply_projection(
#    infl,
#    cols = c("date", "headline_yoy")
#  )
#  
#  head(infl_basic)

## -----------------------------------------------------------------------------
#  infl_three_cols <- apply_projection(
#    infl,
#    cols = c("date", "headline_yoy", "food_yoy")
#  )

## -----------------------------------------------------------------------------
#  # Rename all columns — no selection, every column is kept
#  infl_renamed <- apply_projection(
#    infl,
#    rename = c(
#      Date     = "date",
#      Headline = "headline_yoy",
#      Food     = "food_yoy"
#    )
#  )

## -----------------------------------------------------------------------------
#  # This will fail — no names on the left-hand side
#  apply_projection(infl, rename = c("headline_yoy"))
#  #> Error: `rename` must be a named vector: c(new_name = 'old_name')

## -----------------------------------------------------------------------------
#  infl_clean <- apply_projection(
#    infl,
#    cols   = c("date", "headline_yoy", "food_yoy"),
#    rename = c(
#      Date     = "date",
#      Headline = "headline_yoy",
#      Food     = "food_yoy"
#    )
#  )
#  
#  head(infl_clean)
#  #>         Date Headline     Food
#  #> 1 2010-01-01    11.80    14.60
#  #> 2 2010-02-01    14.05    17.02
#  #> ...

## -----------------------------------------------------------------------------
#  # Put food before headline, even though we selected headline first
#  infl_reordered <- apply_projection(
#    infl,
#    cols  = c("date", "headline_yoy", "food_yoy"),
#    order = c("food_yoy", "headline_yoy", "date")
#  )

## -----------------------------------------------------------------------------
#  infl_report <- apply_projection(
#    infl,
#    cols   = c("date", "headline_yoy", "food_yoy"),
#    rename = c(Date = "date", Headline = "headline_yoy", Food = "food_yoy"),
#    order  = c("Date", "Headline", "Food")
#  )

## -----------------------------------------------------------------------------
#  policy_brief <- apply_projection(
#    infl,
#    cols   = c("date", "headline_yoy", "core_ex_farm_yoy"),
#    rename = c(Date = "date", Headline = "headline_yoy", Core = "core_ex_farm_yoy"),
#    reason = "Quarterly macroeconomic policy brief — Q1 2025"
#  )

## -----------------------------------------------------------------------------
#  manifest <- attr(policy_brief, "projection_manifest")
#  
#  manifest[[1]]$timestamp  # When it ran
#  manifest[[1]]$reason     # Your label
#  manifest[[1]]$cols_kept  # Which columns were kept

## -----------------------------------------------------------------------------
#  # Step 1 — select
#  step1 <- apply_projection(
#    infl,
#    cols   = c("date", "headline_yoy", "food_yoy"),
#    reason = "Initial column selection"
#  )
#  
#  # Step 2 — rename (applied to step1's output)
#  step2 <- apply_projection(
#    step1,
#    rename = c(Date = "date", Headline = "headline_yoy", Food = "food_yoy"),
#    reason = "Standardize names for reporting"
#  )
#  
#  # Both steps are recorded
#  attr(step2, "projection_manifest")
#  #> [[1]]
#  #> $action    "projection"
#  #> $reason    "Initial column selection"
#  #> $timestamp  ...
#  #>
#  #> [[2]]
#  #> $action    "projection"
#  #> $reason    "Standardize names for reporting"
#  #> $timestamp  ...

## -----------------------------------------------------------------------------
#  library(dplyr)
#  
#  infl |>
#    apply_projection(
#      cols   = c("date", "headline_yoy", "food_yoy"),
#      rename = c(Date = "date", Headline = "headline_yoy", Food = "food_yoy"),
#      reason = "Pipeline transformation for dashboard"
#    )

## -----------------------------------------------------------------------------
#  exchange <- cbn("exchange_rates")
#  
#  # Give both datasets a common "Date" column name
#  infl_std <- apply_projection(
#    infl,
#    rename = c(Date = "date"),
#    reason = "Standard schema — macro datasets"
#  )
#  
#  exchange_std <- apply_projection(
#    exchange,
#    rename = c(Date = "ratedate"),
#    reason = "Standard schema — macro datasets"
#  )
#  
#  # Now both share the same "Date" column and can be merged cleanly
#  macro <- merge(infl_std, exchange_std, by = "Date")

