#' Standardize CBN Daily Crude Oil Data
#' @noRd
standardize_cbn_daily_crude <- function(data) {
  data.frame(
    date = as.Date(data$period, format = "%d/%m/%Y"),
    price_bonny_light   = as.numeric(data$crudeOilPrice),
    domestic_production = as.numeric(data$domProd),
    export              = as.numeric(data$crudeOilExp)
  )
}


#' Standardize CBN Crude Oil Data
#' @noRd
standardize_cbn_crude_oil <- function(data) {
  # Similar simple standardization
  if (!is.data.frame(data)) return(data)
  return(data)
}

#' Standardize CBN Daily Crude Oil Data
#' @noRd
standardize_cbn_daily_crude <- function(data) {
  if (!is.data.frame(data)) return(data)
  return(data)
}

#' Standardize CBN Financial Data
#' @noRd
standardize_cbn_financial_data <- function(data) {
  if (!is.data.frame(data)) return(data)
  return(data)
}


#' Standardize CBN Foreign Exchange Reserves
#' @noRd
standardize_cbn_fx_reserves <- function(data) {
  if (!is.data.frame(data)) return(data)
  return(data)
}

#' Standardize CBN Discount Rates
#' @noRd
standardize_cbn_discount_rates <- function(data) {
  if (!is.data.frame(data)) return(data)
  return(data)
}

#' Standardize CBN Interbank Rates
#' @noRd
standardize_cbn_interbank_rates <- function(data) {
  if (!is.data.frame(data)) return(data)
  return(data)
}

#' Standardize CBN Money & Credit Statistics
#' @noRd
standardize_cbn_money_credit <- function(data) {
  if (!is.data.frame(data)) return(data)

  # CBN Money & Credit data might need special handling
  # Example: Ensure column names, handle missing values, etc.

  # Check for common column patterns
  money_cols <- c("tyear", "tmonth", "moneySupply_M3", "moneySupply_M2",
                  "narrowMoney", "quasiMoney")

  # If these columns exist, data is probably fine
  if (any(money_cols %in% names(data))) {
    return(data)
  }

  # Could add more specific cleaning here if needed
  return(data)
}

#' Standardize CBN Money Market Indicators
#' @noRd
standardize_cbn_money_market <- function(data) {
  if (!is.data.frame(data)) return(data)
  return(data)
}

#' Standardize CBN Government Securities
#' @noRd
standardize_cbn_securities <- function(data) {
  if (!is.data.frame(data)) return(data)
  return(data)
}

#' Standardize CBN GDP Data
#' @noRd
standardize_cbn_gdp <- function(data) {
  if (!is.data.frame(data)) return(data)
  return(data)
}

#' Standardize CBN Inflation Data
#' @noRd
standardize_cbn_inflation <- function(data) {
  if (!is.data.frame(data)) return(data)
  return(data)
}

#' Standardize CBN International Payments
#' @noRd
standardize_cbn_international_payments <- function(data) {
  if (!is.data.frame(data)) return(data)
  return(data)
}

#' Standardize CBN Assets & Liabilities
#' @noRd
standardize_cbn_assets_liabilities <- function(data) {
  if (!is.data.frame(data)) return(data)
  return(data)
}

#' Standardize CBN Assets & Liabilities
#' @noRd
standardize_cbn_financial_data <- function(data) {
  if (!is.data.frame(data)) return(data)
  return(data)
}

#' Standardize CBN Discount Window
#' @noRd
standardize_cbn_discount_rates <- function(data) {
  if (!is.data.frame(data)) return(data)
  return(data)
}

#' Standardize NBS CPI Data
#' @noRd
standardize_nbs_cpi <- function(data) {
  # NBS data from your nbsGet function should be in good shape
  # This function handles edge cases or version differences

  if (!is.data.frame(data)) return(data)

  # Ensure proper column names
  expected_cols <- c("Date", "Year", "Month", "Category", "Monthly_Index",
                     "Twelve_Month_Avg", "Month_on_Change", "Year_on_Change",
                     "Twelve_Month_Avg_Change")

  # If columns are missing, try to infer them
  if (!all(expected_cols %in% names(data)) && ncol(data) >= length(expected_cols)) {
    # Use first n columns where n = length(expected_cols)
    names(data)[1:min(length(expected_cols), ncol(data))] <-
      expected_cols[1:min(length(expected_cols), ncol(data))]
  }

  return(data)
}
