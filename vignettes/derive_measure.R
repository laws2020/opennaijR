## ----setup, include=FALSE-----------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment  = "#>",
  eval     = FALSE
)

## -----------------------------------------------------------------------------
#  library(opennaijR)
#  
#  infl <- cbn("inflation")
#  
#  # How far is headline above food inflation in each period?
#  infl_gap <- derive_measure(
#    infl,
#    gap_headline_food = headline_yoy - food_yoy
#  )
#  
#  head(infl_gap[, c("date", "headline_yoy", "food_yoy", "gap_headline_food")])

## -----------------------------------------------------------------------------
#  # What fraction of headline inflation is food-driven?
#  infl_share <- derive_measure(
#    infl,
#    food_share_pct = (food_yoy / headline_yoy) * 100
#  )
#  
#  # How does core compare to headline?
#  infl_ratio <- derive_measure(
#    infl,
#    core_to_headline = core_ex_farm_yoy / headline_yoy
#  )

## -----------------------------------------------------------------------------
#  infl_abs <- derive_measure(
#    infl,
#    abs_gap = abs(headline_yoy - core_ex_farm_yoy)
#  )

## -----------------------------------------------------------------------------
#  infl_mom <- derive_measure(
#    infl,
#    headline_change = headline_yoy - lag(headline_yoy)
#  )

## -----------------------------------------------------------------------------
#  infl_growth <- derive_measure(
#    infl,
#    headline_growth_pct =
#      (headline_yoy - lag(headline_yoy)) / lag(headline_yoy) * 100
#  )

## -----------------------------------------------------------------------------
#  infl_annual_delta <- derive_measure(
#    infl,
#    annual_delta = headline_yoy - lag(headline_yoy, 12)
#  )

## -----------------------------------------------------------------------------
#  library(zoo)
#  
#  infl_roll <- derive_measure(
#    infl,
#    headline_3m_avg = rollmean(headline_yoy, k = 3, fill = NA, align = "right")
#  )

## -----------------------------------------------------------------------------
#  # Is inflation accelerating this period compared to last?
#  infl_accel <- derive_measure(
#    infl,
#    accelerating = headline_yoy > lag(headline_yoy)
#  )
#  
#  # Is food inflation the dominant driver?
#  infl_food_driven <- derive_measure(
#    infl,
#    food_dominant = food_yoy > headline_yoy
#  )

## -----------------------------------------------------------------------------
#  infl_regime <- derive_measure(
#    infl,
#    inflation_class = ifelse(
#      headline_yoy < 0,  "Deflation",
#      ifelse(
#        headline_yoy <= 5,  "Low",
#        ifelse(
#          headline_yoy <= 15, "Moderate",
#          "High"
#        )
#      )
#    ),
#    reason = "Three-level inflation regime classification"
#  )

## -----------------------------------------------------------------------------
#  infl_regime_num <- derive_measure(
#    infl,
#    regime_code = ifelse(
#      headline_yoy < 0,   0L,
#      ifelse(
#        headline_yoy <= 5,  1L,
#        ifelse(
#          headline_yoy <= 15, 2L,
#          3L
#        )
#      )
#    ),
#    reason = "Numeric regime encoding for regression"
#  )

## -----------------------------------------------------------------------------
#  infl_decomp <- derive_measure(
#    infl,
#    gap            = headline_yoy - core_ex_farm_yoy,
#    food_pressure  = food_yoy     - core_ex_farm_yoy,
#    accelerating   = headline_yoy > lag(headline_yoy),
#    high_regime    = headline_yoy > 15,
#    reason         = "Full structural decomposition for policy brief"
#  )

## -----------------------------------------------------------------------------
#  step1 <- derive_measure(
#    infl,
#    gap = headline_yoy - food_yoy,
#    reason = "Compute baseline gap"
#  )
#  
#  step2 <- derive_measure(
#    step1,
#    gap_change = gap - lag(gap),
#    reason = "Measure whether gap is widening"
#  )
#  
#  # Both derivation steps are recorded
#  manifest <- attr(step2, "derive_manifest")
#  
#  manifest[[1]]$expressions  # step 1 expressions
#  manifest[[2]]$expressions  # step 2 expressions

## -----------------------------------------------------------------------------
#  infl_features <- derive_measure(
#    infl,
#    gap   = headline_yoy - food_yoy,
#    share = (food_yoy / headline_yoy) * 100,
#    reason = "Replication of 2025 inflation study"
#  )
#  
#  manifest <- attr(infl_features, "derive_manifest")
#  
#  manifest[[1]]$timestamp    # Exact time the function ran
#  manifest[[1]]$expressions  # The R expressions that were evaluated
#  manifest[[1]]$reason       # Your label

## -----------------------------------------------------------------------------
#  library(dplyr)
#  
#  model_ready <- infl |>
#    derive_measure(
#      gap        = headline_yoy - core_ex_farm_yoy,
#      accel      = headline_yoy - lag(headline_yoy),
#      high_regime = headline_yoy > 15,
#      reason     = "Feature set for regression model"
#    )

## -----------------------------------------------------------------------------
#  exchange <- cbn("exchange_rates")
#  
#  exchange_features <- derive_measure(
#    exchange,
#    spread       = selling_rate - buying_rate,
#    mid_rate     = (buying_rate + selling_rate) / 2,
#    buying_pct   = (buying_rate - lag(buying_rate)) / lag(buying_rate) * 100,
#    depreciation = buying_rate > lag(buying_rate),
#    movement     = ifelse(
#      buying_rate > lag(buying_rate), "Depreciation",
#      ifelse(buying_rate < lag(buying_rate), "Appreciation", "Stable")
#    ),
#    reason = "Exchange rate feature engineering"
#  )

## -----------------------------------------------------------------------------
#  infl_std    <- apply_projection(infl,     rename = c(Date = "date"))
#  exchange_std <- apply_projection(exchange, rename = c(Date = "ratedate"))
#  
#  macro <- merge(infl_std, exchange_std, by = "Date")
#  
#  macro_features <- derive_measure(
#    macro,
#    real_exchange_change = buying_pct - headline_yoy,
#    reason = "Compare currency depreciation against inflation"
#  )

