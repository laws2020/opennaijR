## ----loadPackage, warning=FALSE-----------------------------------------------
library(opennaijR)

## ----exploratory, warning=FALSE-----------------------------------------------
discover_datasets()

## ----searching, warning=FALSE-------------------------------------------------
discover_datasets(dataset = "exchange")

## ----searching_within, warning=FALSE------------------------------------------
discover_datasets(source = "cbn", dataset = "inflation")

## ----fetchin_data, warning=FALSE----------------------------------------------
exchange_rates <- cbn("exchange_rates")

## ----behind_scene, warning=FALSE, eval=FALSE----------------------------------
#  cbn("exchange_rates")

## ----selection, warning=FALSE-------------------------------------------------
cbn("exchange_rates", variables = c("currency", "buying_rate"))

## ----rang, warning=FALSE------------------------------------------------------
cbn("exchange_rates", from = "2020-01-01", to = "2023-12-31")

## ----exchange_rates_fetch, eval=FALSE-----------------------------------------
#  exchange_rates <- cbn("exchange_rates")

