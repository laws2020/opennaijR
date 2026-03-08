## ----setup, include=FALSE-----------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment  = "#>",
  eval     = FALSE
)

## -----------------------------------------------------------------------------
#  library(opennaijR)
#  
#  infl     <- cbn("inflation")
#  exchange <- cbn("exchange_rates")

## -----------------------------------------------------------------------------
#  infl_clean <- apply_projection(
#    infl,
#    cols   = c("date", "headline_yoy", "food_yoy", "core_ex_farm_yoy"),
#    rename = c(
#      Date     = "date",
#      Headline = "headline_yoy",
#      Food     = "food_yoy",
#      Core     = "core_ex_farm_yoy"
#    ),
#    reason = "Select and rename for macro regime analysis"
#  )
#  
#  exchange_clean <- apply_projection(
#    exchange,
#    cols   = c("date", "buying_rate"),
#    rename = c(Date = "date", Rate = "buying_rate"),
#    reason = "Minimal exchange rate schema"
#  )
#  
#  head(infl_clean)

## -----------------------------------------------------------------------------
#  infl_regimes <- derive_measure(
#    infl_clean,
#    Headline_Regime = ifelse(
#      Headline < 0,  "Deflation",
#      ifelse(
#        Headline <= 5,  "Low",
#        ifelse(
#          Headline <= 15, "Moderate",
#          "High"
#        )
#      )
#    ),
#    Food_Regime = ifelse(
#      Food < 0,  "Deflation",
#      ifelse(
#        Food <= 5,  "Low",
#        ifelse(
#          Food <= 15, "Moderate",
#          "High"
#        )
#      )
#    ),
#    reason = "Construct headline and food inflation regimes"
#  )

## -----------------------------------------------------------------------------
#  table(infl_regimes$Headline_Regime)

## -----------------------------------------------------------------------------
#  table(infl_regimes$Food_Regime)

## -----------------------------------------------------------------------------
#  regime_table <- table(
#    Headline = infl_regimes$Headline_Regime,
#    Food     = infl_regimes$Food_Regime
#  )
#  
#  regime_table

## -----------------------------------------------------------------------------
#  prop.table(regime_table, margin = 1)

## -----------------------------------------------------------------------------
#  chisq.test(regime_table)

## -----------------------------------------------------------------------------
#  model1 <- lm(Headline ~ Food, data = infl_regimes)
#  summary(model1)

## -----------------------------------------------------------------------------
#  model2 <- lm(Headline ~ Food + Core, data = infl_regimes)
#  summary(model2)

## -----------------------------------------------------------------------------
#  macro <- merge(infl_regimes, exchange_clean, by = "Date")
#  
#  model3 <- lm(Headline ~ Food + Core + Rate, data = macro)
#  summary(model3)

## -----------------------------------------------------------------------------
#  # Create the binary outcome
#  infl_binary <- derive_measure(
#    infl_regimes,
#    High_Inflation = Headline > 15,
#    reason         = "Binary indicator for high-inflation regime"
#  )
#  
#  # Estimate the model
#  logit_model <- glm(
#    High_Inflation ~ Food,
#    data   = infl_binary,
#    family = binomial()
#  )
#  
#  summary(logit_model)

## -----------------------------------------------------------------------------
#  exp(coef(logit_model))

## -----------------------------------------------------------------------------
#  macro_binary <- merge(infl_binary, exchange_clean, by = "Date")
#  
#  logit_model2 <- glm(
#    High_Inflation ~ Food + Rate,
#    data   = macro_binary,
#    family = binomial()
#  )
#  
#  summary(logit_model2)
#  exp(coef(logit_model2))

## -----------------------------------------------------------------------------
#  model_interaction <- lm(
#    Headline ~ Food * Core,
#    data = infl_regimes
#  )
#  
#  summary(model_interaction)

## -----------------------------------------------------------------------------
#  manifest <- attr(infl_binary, "derive_manifest")
#  
#  # How many derivation steps were recorded?
#  length(manifest)
#  
#  # Inspect the most recent step
#  tail(manifest, 1)[[1]]$timestamp
#  tail(manifest, 1)[[1]]$expressions
#  tail(manifest, 1)[[1]]$reason

## -----------------------------------------------------------------------------
#  # ── 1. Data ────────────────────────────────────────────────────────────────────
#  infl     <- cbn("inflation")
#  exchange <- cbn("exchange_rates")
#  
#  # ── 2. Schema ──────────────────────────────────────────────────────────────────
#  infl_clean <- apply_projection(
#    infl,
#    cols   = c("date", "headline_yoy", "food_yoy", "core_ex_farm_yoy"),
#    rename = c(Date = "date", Headline = "headline_yoy",
#               Food = "food_yoy", Core = "core_ex_farm_yoy"),
#    reason = "Select and rename for macro regime analysis"
#  )
#  
#  exchange_clean <- apply_projection(
#    exchange,
#    cols   = c("date", "buying_rate"),
#    rename = c(Date = "date", Rate = "buying_rate")
#  )
#  
#  # ── 3. Features ────────────────────────────────────────────────────────────────
#  infl_regimes <- derive_measure(
#    infl_clean,
#    Headline_Regime = ifelse(Headline < 0, "Deflation",
#                      ifelse(Headline <= 5, "Low",
#                      ifelse(Headline <= 15, "Moderate", "High"))),
#    Food_Regime     = ifelse(Food < 0, "Deflation",
#                      ifelse(Food <= 5, "Low",
#                      ifelse(Food <= 15, "Moderate", "High"))),
#    High_Inflation  = Headline > 15,
#    reason          = "Regime construction and binary flag"
#  )
#  
#  # ── 4. Association ─────────────────────────────────────────────────────────────
#  regime_table <- table(infl_regimes$Headline_Regime, infl_regimes$Food_Regime)
#  prop.table(regime_table, margin = 1)
#  chisq.test(regime_table)
#  
#  # ── 5. Regression ──────────────────────────────────────────────────────────────
#  model1 <- lm(Headline ~ Food,        data = infl_regimes)
#  model2 <- lm(Headline ~ Food + Core, data = infl_regimes)
#  
#  macro   <- merge(infl_regimes, exchange_clean, by = "Date")
#  model3  <- lm(Headline ~ Food + Core + Rate, data = macro)
#  
#  logit1  <- glm(High_Inflation ~ Food + Rate, data = macro, family = binomial())
#  
#  # ── 6. Manifest ────────────────────────────────────────────────────────────────
#  attr(infl_regimes, "derive_manifest")

