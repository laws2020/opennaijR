## ----setup, include=FALSE-----------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment  = "#>",
  eval     = FALSE
)

## ----basic-plot, eval=TRUE, fig.height=5, fig.width=7-------------------------
library(opennaijR)

infl <- cbn("inflation")

plot_inflation_shocks(infl)

## ----food-inflation, eval=TRUE, fig.height=5, fig.width=7---------------------
# Food inflation — typically more volatile than headline
plot_inflation_shocks(
  data    = infl,
  val_col = "food_yoy",
  title   = "Nigeria Food Inflation Trends"
)

## ----core-inflation, eval=TRUE, fig.height=5, fig.width=7---------------------
# Core inflation — strips out farm produce and energy
plot_inflation_shocks(
  data    = infl,
  val_col = "core_ex_farm_yoy",
  title   = "Nigeria Core Inflation Trends"
)

## ----filter-recent, eval=TRUE, fig.height=5, fig.width=7----------------------
# Zoom in on the post-COVID and subsidy-removal period
recent <- infl[infl$date >= as.Date("2020-01-01"), ]

plot_inflation_shocks(
  data  = recent,
  title = "Inflation Volatility: 2020 – Present"
)

## ----filter-era, eval=TRUE, fig.height=5, fig.width=7-------------------------
# Isolate the 2016 recession era
recession_era <- infl[
  infl$date >= as.Date("2015-01-01") &
  infl$date <= as.Date("2018-12-01"), 
]

plot_inflation_shocks(
  data  = recession_era,
  title = "Inflation During the 2016 Recession"
)

## ----external-data, eval=TRUE, fig.height=5, fig.width=7----------------------
# A data frame with non-standard column names
external_df <- data.frame(
  period = seq(as.Date("2015-01-01"), as.Date("2024-01-01"), by = "month"),
  rate   = runif(109, 10, 30)
)

plot_inflation_shocks(
  data     = external_df,
  date_col = "period",
  val_col  = "rate",
  title    = "Custom Macroeconomic Series with Shock Overlay"
)

## ----derive-then-plot, eval=TRUE, fig.height=5, fig.width=7-------------------
# Derive the food-headline gap, then visualise it
infl_gap <- derive_measure(
  infl,
  food_gap = food_yoy - headline_yoy,
  reason   = "Food premium over headline inflation"
)

plot_inflation_shocks(
  data    = infl_gap,
  val_col = "food_gap",
  title   = "Food Inflation Premium Over Headline"
)

## ----batch-plot, eval=TRUE, fig.height=10, fig.width=7------------------------
metrics <- c(
  "headline_yoy",
  "food_yoy",
  "core_ex_farm_yoy"
)

labels <- c(
  "Headline Inflation",
  "Food Inflation",
  "Core Inflation (Ex-Farm)"
)

par(mfrow = c(3, 1), mar = c(4, 4, 3, 1))

for (i in seq_along(metrics)) {
  plot_inflation_shocks(
    data    = infl,
    val_col = metrics[i],
    title   = labels[i]
  )
}

# Reset graphics layout after use
par(mfrow = c(1, 1))

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

