## ----setup, include=FALSE-----------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment  = "#>",
  eval     = FALSE
)

## ----basic-plot, fig.height=5, fig.width=7------------------------------------
#  library(opennaijR)
#  
#  infl <- cbn("inflation")
#  
#  plot_inflation_shocks(infl)

## ----food-plot, fig.height=5, fig.width=7-------------------------------------
#  # Food inflation -- most sensitive to supply shocks and import costs
#  plot_inflation_shocks(
#    data    = infl,
#    val_col = "food_yoy",
#    title   = "Nigeria Food Inflation Trends"
#  )

## ----core-plot, fig.height=5, fig.width=7-------------------------------------
#  # Core inflation -- strips out farm produce and energy
#  plot_inflation_shocks(
#    data    = infl,
#    val_col = "core_ex_farm_yoy",
#    title   = "Nigeria Core Inflation Trends"
#  )

## ----filter-recent, fig.height=5, fig.width=7---------------------------------
#  # Focus on the post-COVID and subsidy-removal period
#  recent_data <- infl[infl$date >= as.Date("2020-01-01"), ]
#  
#  plot_inflation_shocks(
#    data  = recent_data,
#    title = "Inflation Volatility: 2020 to Present"
#  )

## ----filter-recession, fig.height=5, fig.width=7------------------------------
#  # Isolate the 2016 recession era
#  recession_era <- infl[
#    infl$date >= as.Date("2015-01-01") &
#    infl$date <= as.Date("2018-12-01"),
#  ]
#  
#  plot_inflation_shocks(
#    data  = recession_era,
#    title = "Inflation During the 2016 Recession"
#  )

## ----external-data, fig.height=5, fig.width=7---------------------------------
#  external_df <- data.frame(
#    period = seq(as.Date("2015-01-01"), as.Date("2024-01-01"), by = "month"),
#    rate   = runif(109, 10, 30)
#  )
#  
#  plot_inflation_shocks(
#    data     = external_df,
#    date_col = "period",
#    val_col  = "rate",
#    title    = "Custom Series with Nigerian Shock Overlay"
#  )

## ----derive-then-plot, fig.height=5, fig.width=7------------------------------
#  infl_gap <- derive_measure(
#    infl,
#    food_gap = food_yoy - headline_yoy,
#    reason   = "Food premium over headline inflation"
#  )
#  
#  plot_inflation_shocks(
#    data    = infl_gap,
#    val_col = "food_gap",
#    title   = "Food Inflation Premium Over Headline"
#  )

## ----batch-plot, fig.height=10, fig.width=7-----------------------------------
#  metrics <- c("headline_yoy", "food_yoy", "core_ex_farm_yoy")
#  
#  labels  <- c(
#    "Headline Inflation",
#    "Food Inflation",
#    "Core Inflation (Ex-Farm)"
#  )
#  
#  par(mfrow = c(3, 1), mar = c(4, 4, 3, 1))
#  
#  for (i in seq_along(metrics)) {
#    plot_inflation_shocks(
#      data    = infl,
#      val_col = metrics[i],
#      title   = labels[i]
#    )
#  }
#  
#  par(mfrow = c(1, 1))  # always reset the layout after use

## ----save-plot, eval=FALSE----------------------------------------------------
#  png(
#    filename = "nigeria_headline_inflation.png",
#    width    = 2400,
#    height   = 1500,
#    res      = 300
#  )
#  
#  plot_inflation_shocks(
#    data  = infl,
#    title = "Nigeria Headline Inflation with Macroeconomic Shocks"
#  )
#  
#  dev.off()

## ----all-three, fig.height=5, fig.width=7-------------------------------------
#  plot_inflation(infl)

## ----single-measure, fig.height=5, fig.width=7--------------------------------
#  # Headline only
#  plot_inflation(
#    data    = infl,
#    measure = "headline",
#    title   = "Nigeria Headline Inflation"
#  )

## ----food-only, fig.height=5, fig.width=7-------------------------------------
#  # Food only
#  plot_inflation(
#    data    = infl,
#    measure = "food",
#    title   = "Nigeria Food Inflation"
#  )

## ----two-components, fig.height=5, fig.width=7--------------------------------
#  # Headline vs Core -- useful for monetary policy analysis
#  # Core strips food and energy, so divergence signals supply-side pressure
#  plot_inflation(
#    data    = infl,
#    measure = c("headline", "core"),
#    title   = "Headline vs Core Inflation"
#  )

## ----headline-food, fig.height=5, fig.width=7---------------------------------
#  # Headline vs Food -- how much is food driving the overall rate?
#  plot_inflation(
#    data    = infl,
#    measure = c("headline", "food"),
#    title   = "Headline vs Food Inflation"
#  )

## ----yoy-vs-12m, fig.height=5, fig.width=7------------------------------------
#  # Year-on-year -- shows monthly volatility
#  plot_inflation(
#    data  = infl,
#    type  = "yoy",
#    title = "Nigeria Inflation: Year-on-Year"
#  )

## ----smoothed, fig.height=5, fig.width=7--------------------------------------
#  # 12-month average -- shows the underlying trend
#  plot_inflation(
#    data  = infl,
#    type  = "12m",
#    title = "Nigeria Inflation: 12-Month Average"
#  )

## ----combined, fig.height=5, fig.width=7--------------------------------------
#  # Smoothed food and core -- structural comparison
#  plot_inflation(
#    data    = infl,
#    measure = c("food", "core"),
#    type    = "12m",
#    title   = "Food vs Core Inflation: 12-Month Trend"
#  )

## ----error-example, eval=FALSE------------------------------------------------
#  # If "core_ex_farm_12m" does not exist in your dataset:
#  plot_inflation(infl, measure = "core", type = "12m")
#  #> Error: Requested inflation measure(s) not found in data.

