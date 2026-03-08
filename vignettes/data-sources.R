## ----setup, include=FALSE-----------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment  = "#>",
  eval     = FALSE
)

## ----discover-----------------------------------------------------------------
#  library(opennaijR)
#  
#  discover_datasets()

## ----inflation----------------------------------------------------------------
#  infl <- nga_cbn("inflation", auto.assign = FALSE)

## ----exchange-----------------------------------------------------------------
#  exch <- nga_cbn("exchange_rates", auto.assign = FALSE)

## ----crude--------------------------------------------------------------------
#  oil <- nga_cbn("crude_oil", auto.assign = FALSE)

## ----money--------------------------------------------------------------------
#  money <- nga_cbn("money_credit", auto.assign = FALSE)

## ----mpr----------------------------------------------------------------------
#  mkt <- nga_cbn("money_market", auto.assign = FALSE)

## ----gdp----------------------------------------------------------------------
#  gdp <- nga_cbn("gdp_ng", auto.assign = FALSE)

## ----index--------------------------------------------------------------------
#  # See all datasets with keys and descriptions
#  discover_datasets()

