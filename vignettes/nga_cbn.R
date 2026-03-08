## ----setup, include=FALSE-----------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment  = "#>",
  eval     = FALSE
)

## ----auto-assign--------------------------------------------------------------
#  library(opennaijR)
#  
#  nga_cbn("inflation")
#  
#  head(inflation)

## ----check-env----------------------------------------------------------------
#  ls()
#  #> [1] "inflation"
#  
#  class(inflation)
#  #> [1] "opennaijR_tbl" "data.frame"
#  
#  head(inflation[, c("date", "headline_yoy", "food_yoy")])
#  #>         date headline_yoy food_yoy
#  #> 1 2010-01-01        11.80    14.60
#  #> 2 2010-02-01        14.05    17.02

## ----explicit-assign----------------------------------------------------------
#  df <- nga_cbn("exchange_rates", auto.assign = FALSE)
#  
#  head(df)

## ----multi-load---------------------------------------------------------------
#  datasets <- c("inflation", "exchange_rates", "crude_oil")
#  
#  for (key in datasets) {
#    nga_cbn(key)
#  }
#  
#  # All three now exist as named objects in your environment
#  ls()
#  #> [1] "crude_oil"      "exchange_rates" "inflation"
#  
#  head(inflation)
#  head(exchange_rates)
#  head(crude_oil)

## ----lapply-load--------------------------------------------------------------
#  invisible(lapply(datasets, nga_cbn))

## ----from-date----------------------------------------------------------------
#  # All inflation data from January 2015 onwards
#  recent_infl <- nga_cbn(
#    "inflation",
#    from        = "2015-01-01",
#    auto.assign = FALSE
#  )

## ----date-window--------------------------------------------------------------
#  # The 2016 recession period only
#  recession <- nga_cbn(
#    "inflation",
#    from        = "2015-01-01",
#    to          = "2018-12-31",
#    auto.assign = FALSE
#  )

## ----recent-12m---------------------------------------------------------------
#  # Dynamic: always retrieves the last 12 months regardless of when you run it
#  nga_cbn(
#    "exchange_rates",
#    from = as.character(Sys.Date() - 365),
#    to   = as.character(Sys.Date())
#  )

## ----variables-filter---------------------------------------------------------
#  # Return only headline and food inflation -- skip all other columns
#  infl_narrow <- nga_cbn(
#    "inflation",
#    variables   = c("headline_yoy", "food_yoy"),
#    auto.assign = FALSE
#  )
#  
#  names(infl_narrow)
#  #> [1] "date"         "headline_yoy" "food_yoy"

## ----cache-demo---------------------------------------------------------------
#  # First call -- downloads from CBN (takes a moment)
#  nga_cbn("inflation")
#  
#  # Second call -- loads from local cache (instant)
#  nga_cbn("inflation")

## ----refresh------------------------------------------------------------------
#  # Bypass the cache and download the latest data
#  nga_cbn("inflation", refresh = TRUE)

## ----refresh-explicit---------------------------------------------------------
#  # Refresh and capture explicitly
#  infl_latest <- nga_cbn(
#    "inflation",
#    refresh     = TRUE,
#    auto.assign = FALSE
#  )

## ----canonical----------------------------------------------------------------
#  infl_clean <- nga_cbn(
#    "inflation",
#    canonical   = TRUE,    # this is the default
#    auto.assign = FALSE
#  )
#  
#  names(infl_clean)
#  #> [1] "date"             "headline_yoy"     "food_yoy"
#  #>     "core_ex_farm_yoy" ...

## ----raw----------------------------------------------------------------------
#  infl_raw <- nga_cbn(
#    "inflation",
#    raw         = TRUE,
#    auto.assign = FALSE
#  )
#  
#  # Inspect what the CBN API actually returns before any cleaning
#  str(infl_raw)

## ----custom-env---------------------------------------------------------------
#  # Create a dedicated environment for macro data
#  macro_env <- new.env(parent = emptyenv())
#  
#  # Load datasets into that environment instead of .GlobalEnv
#  nga_cbn("inflation",     env = macro_env)
#  nga_cbn("exchange_rates", env = macro_env)
#  
#  # Access them through the environment
#  ls(macro_env)
#  #> [1] "exchange_rates" "inflation"
#  
#  head(macro_env$inflation)

## ----pipeline-----------------------------------------------------------------
#  library(opennaijR)
#  
#  nga_cbn("inflation", auto.assign = FALSE) |>
#    apply_projection(
#      cols   = c("date", "headline_yoy", "food_yoy"),
#      rename = c(Date = "date", Headline = "headline_yoy", Food = "food_yoy"),
#      reason = "Select key series"
#    ) |>
#    derive_measure(
#      gap         = Headline - Food,
#      accelerating = Headline > lag(Headline),
#      reason      = "Diagnostic indicators"
#    ) |>
#    plot_inflation_shocks(
#      val_col = "Headline",
#      title   = "Nigeria Headline Inflation"
#    )

## ----future-pattern, eval=FALSE-----------------------------------------------
#  # Ghana -- Bank of Ghana
#  gha_bog("inflation", from = "2015-01-01")
#  
#  # Kenya -- Central Bank of Kenya
#  ken_cbk("exchange_rates", auto.assign = FALSE)
#  
#  # South Africa -- South African Reserve Bank
#  zaf_sarb("inflation", refresh = TRUE)
#  
#  # Load inflation data from four countries in one loop
#  sources <- list(
#    nga = "nga_cbn",
#    gha = "gha_bog",
#    ken = "ken_cbk",
#    zaf = "zaf_sarb"
#  )
#  
#  for (fn in sources) {
#    do.call(fn, list("inflation"))
#  }

## ----quick-ref, eval=FALSE----------------------------------------------------
#  # Load and auto-assign
#  nga_cbn("inflation")
#  
#  # Load and assign yourself
#  df <- nga_cbn("inflation", auto.assign = FALSE)
#  
#  # Load multiple datasets at once
#  invisible(lapply(c("inflation", "exchange_rates"), nga_cbn))
#  
#  # Filter to a date range
#  nga_cbn("inflation", from = "2020-01-01", to = "2023-12-31")
#  
#  # Filter to specific variables
#  nga_cbn("inflation", variables = c("headline_yoy", "food_yoy"),
#          auto.assign = FALSE)
#  
#  # Force fresh download
#  nga_cbn("inflation", refresh = TRUE)
#  
#  # Get raw uncleaned API response
#  nga_cbn("inflation", raw = TRUE, auto.assign = FALSE)
#  
#  # Load into a specific environment
#  nga_cbn("inflation", env = macro_env)
#  
#  # Full pipeline
#  nga_cbn("inflation", auto.assign = FALSE) |>
#    apply_projection(cols = c("date", "headline_yoy")) |>
#    derive_measure(accel = headline_yoy - lag(headline_yoy))

