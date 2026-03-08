#' @title CBN Dataset Manifest
#' @description Internal manifest defining CBN datasets, canonical IDs, endpoints, aliases, and measures.
#' @keywords internal
.manifest_registry <- function(source) {
  if (source != "cbn") {
    stop(sprintf("Source '%s' not supported yet.", source), call. = FALSE)
  }

  list(

    # =======================
    # Inflation
    # =======================
    inflation_ng = list(
      id        = "cbn_inflation",
      aliases   = c("inflation", "inflation rates"),
      fetch     = list(endpoint = "GetAllInflationRates", method = "GET"),
      frequency = "monthly",
      date      = list(column = "period", name = "date"),
      measures  = list(
        headline_yoy            = list(column = "allItemsYearOn",                        unit = "percent"),
        headline_12m            = list(column = "allItemsAverage",                       unit = "percent"),
        food_yoy                = list(column = "foodYearOn",                            unit = "percent"),
        food_12m                = list(column = "foodAverage",                           unit = "percent"),
        core_ex_farm_yoy        = list(column = "allItemsLessFrmProdYearOn",             unit = "percent"),
        core_ex_farm_12m        = list(column = "allItemsLessFrmProdAverage",            unit = "percent"),
        core_ex_farm_energy_yoy = list(column = "allItemsLessFrmProdAndEnergyYearOn",   unit = "percent"),
        core_ex_farm_energy_12m = list(column = "allItemsLessFrmProdAndEnergyAvg",      unit = "percent")
      ),
      source      = "CBN",
      standardize = "standardize_cbn_inflation"
    ),

    # =======================
    # Exchange Rates (Official / Full Set)
    # =======================
    exchange_rates = list(
      id      = "cbn_exchange_rates",
      aliases = c(
        "exchange rates",
        "forex rates",
        "cbn fx rates",
        "foreign exchange rates"
      ),
      fetch     = list(endpoint = "GetAllExchangeRates", method = "GET"),
      frequency = "daily",
      date      = list(column = "ratedate", name = "date"),
      group     = list(currency = "currency"),
      measures  = list(
        buying_rate  = list(column = "buyingrate",  unit = "NGN"),
        central_rate = list(column = "centralrate", unit = "NGN"),
        selling_rate = list(column = "sellingrate", unit = "NGN")
      ),
      source      = "CBN",
      standardize = "standardize_cbn_exchange"
    ),

    # =======================
    # NFEM Exchange Rates
    # =======================
    nfem_exchange_rates = list(
      id        = "cbn_nfem_rates",
      aliases   = c("nfem", "nfem exchange rates"),
      fetch     = list(endpoint = "GetAllNFEM_Rates", method = "GET"),
      frequency = "daily",
      date      = list(column = "ratedate", format = "%B-%d-%Y"),
      measures  = list(
        closing      = list(column = "closingrate",     unit = "NGN"),
        high         = list(column = "highestrate",     unit = "NGN"),
        low          = list(column = "lowestrate",      unit = "NGN"),
        weighted_avg = list(column = "weightedAvgRate", unit = "NGN"),
        simple_avg   = list(column = "simpleAvgRate",   unit = "NGN"),
        deals        = list(column = "noOfDeals")
      ),
      source      = "CBN",
      standardize = "standardize_cbn_nfem_rates"
    ),

    # =======================
    # Monthly Average Exchange Rates
    # =======================
    monthly_avg_exchange_rates = list(
      id        = "cbn_monthly_avg_exchange",
      aliases   = c("monthly average exchange rate", "average exchange"),
      fetch     = list(endpoint = "GetAllMonthlyAvgExchRates", method = "GET"),
      frequency = "monthly",
      date      = list(column = "period", name = "date"),
      measures  = list(
        ifem_dollar = list(column = "ifemDollar", unit = "NGN/USD"),
        bdc_dollar  = list(column = "bdcDollar",  unit = "NGN/USD"),
        pounds      = list(column = "pounds",     unit = "NGN/GBP"),
        euro        = list(column = "euro",       unit = "NGN/EUR"),
        cfa_franc   = list(column = "cfaFr",      unit = "NGN/CFA")
      ),
      source      = "CBN",
      standardize = "standardize_cbn_monthly_avg_exchange"
    ),

    # =======================
    # Crude Oil Price (Monthly)
    # =======================
    crude_oil = list(
      id        = "cbn_crude_oil",
      aliases   = c("crude oil", "oil price", "bonny light"),
      fetch     = list(endpoint = "GetAllCrudeOilPrices", method = "GET"),
      frequency = "monthly",
      date      = list(column = "period", name = "date"),
      measures  = list(
        price_bonny_light   = list(column = "crudeOilPrice", unit = "USD/barrel"),
        domestic_production = list(column = "domProd",       unit = "million barrels per day"),
        crude_oil_export    = list(column = "crudeOilExp",   unit = "million barrels per day")
      ),
      source      = "CBN",
      standardize = "standardize_cbn_crude_oil"
    ),

    # =======================
    # Daily Crude Oil Price
    # =======================
    daily_crude_oil = list(
      id        = "cbn_daily_crude_oil",
      aliases   = c("daily crude oil", "daily oil price", "bonny light daily"),
      fetch     = list(endpoint = "GetAllDailyCrude", method = "GET"),
      frequency = "daily",
      date      = list(column = "postDate", name = "date", format = "%d/%m/%Y"),
      measures  = list(
        price_bonny_light = list(column = "crudeOilPrice", unit = "USD/barrel")
      ),
      source      = "CBN",
      standardize = "standardize_cbn_daily_crude"
    ),

    # =======================
    # External Reserves
    # NOTE: daily frequency; use fx_reserves for monthly aggregates.
    # Both hit GetAllReserves but are separated by frequency intent.
    # =======================
    external_reserves = list(
      id        = "cbn_external_reserves",
      aliases   = c(
        "external reserves",
        "foreign reserves",
        "exr",
        "cbn reserves"
      ),
      fetch     = list(endpoint = "GetAllReserves", method = "GET"),
      frequency = "daily",
      date      = list(column = "moveDate", name = "date", format = "%d/%m/%Y"),
      measures  = list(
        gross_reserves     = list(column = "gross",        unit = "USD"),
        liquid_reserves    = list(column = "liquid",       unit = "USD"),
        blocked_reserves   = list(column = "blocked",      unit = "USD"),
        blocked_percentage = list(column = "blockPercent", unit = "percent")
      ),
      source      = "CBN",
      standardize = "standardize_cbn_external_reserves"
    ),

    # =======================
    # Money and Credit Statistics
    # =======================
    money_credit = list(
      id      = "cbn_money_credit",
      aliases = c(
        "money and credit",
        "monetary aggregates",
        "money supply",
        "credit statistics"
      ),
      fetch     = list(endpoint = "GetAllMoneyAndCreditStats", method = "GET"),
      frequency = "monthly",
      date      = list(column = "period", name = "date"),
      measures  = list(
        broad_money_m3                = list(column = "moneySupply_M3",              unit = "NGN Billion"),
        money_supply_m2               = list(column = "moneySupply_M2",              unit = "NGN Billion"),
        narrow_money                  = list(column = "narrowMoney",                 unit = "NGN Billion"),
        quasi_money                   = list(column = "quasiMoney",                  unit = "NGN Billion"),
        currency_outside_banks        = list(column = "currencyOutsideBanks",        unit = "NGN Billion"),
        currency_in_circulation       = list(column = "currencyInCirculation",       unit = "NGN Billion"),
        bank_reserves                 = list(column = "bankReserves",                unit = "NGN Billion"),
        base_money                    = list(column = "baseMoney",                   unit = "NGN Billion"),
        special_intervention_reserves = list(column = "specialInterventionReserves", unit = "NGN Billion"),
        net_foreign_assets            = list(column = "netForeignAssets",            unit = "NGN Billion"),
        net_domestic_assets           = list(column = "netDomesticAssets",           unit = "NGN Billion"),
        net_domestic_credit           = list(column = "netDomesticCredit",           unit = "NGN Billion"),
        credit_to_government          = list(column = "creditToGovernment",          unit = "NGN Billion"),
        credit_to_government_federal  = list(column = "creditToGovernmentFed",       unit = "NGN Billion"),
        credit_to_private_sector      = list(column = "creditToPrivateSector",       unit = "NGN Billion"),
        other_assets_net              = list(column = "otherAssetsNet",              unit = "NGN Billion")
      ),
      source      = "CBN",
      standardize = "standardize_cbn_money_credit"
    ),

    # =======================
    # Money Market Indicators
    # =======================
    money_market = list(
      id      = "cbn_money_market",
      aliases = c(
        "money market",
        "interest rates",
        "money market indicators",
        "cbn policy rates"
      ),
      fetch     = list(endpoint = "GetAllMoneyMarketIndicators", method = "GET"),
      frequency = "monthly",
      date      = list(column = "period", name = "date"),
      measures  = list(
        interbank_call_rate     = list(column = "interBankCallRate",    unit = "percent"),
        minimum_rediscount_rate = list(column = "mrr",                  unit = "percent"),
        monetary_policy_rate    = list(column = "mpr",                  unit = "percent"),
        treasury_bill_rate      = list(column = "treasuryBill",         unit = "percent"),
        savings_deposit_rate    = list(column = "savingsDeposit",       unit = "percent"),
        deposit_1m_rate         = list(column = "oneMonthDeposit",      unit = "percent"),
        deposit_3m_rate         = list(column = "threeMonthsDeposit",   unit = "percent"),
        deposit_6m_rate         = list(column = "sixMonthsDeposit",     unit = "percent"),
        deposit_12m_rate        = list(column = "twelveMonthsDeposit",  unit = "percent"),
        prime_lending_rate      = list(column = "primeLending",         unit = "percent"),
        maximum_lending_rate    = list(column = "maxLending",           unit = "percent")
      ),
      source      = "CBN",
      standardize = "standardize_cbn_money_market"
    ),

    # =======================
    # Interbank Rates
    # =======================
    interbank_rates = list(
      id        = "cbn_interbank_rates",
      aliases   = c(
        "interbank rates",
        "inter-bank rates",
        "obb rate",
        "weighted average interbank rate"
      ),
      fetch     = list(endpoint = "GetAllInterbankRates", method = "GET"),
      frequency = "daily",
      date      = list(column = "ratedate", format = "%d/%m/%Y"),
      group     = list(rate_type = "ratetype"),
      measures  = list(
        rate_type        = list(column = "ratetype",        unit = "percent"),
        range            = list(column = "range",           unit = "percent"),
        weighted_average = list(column = "weightedaverage", unit = "percent")
      ),
      source      = "CBN",
      standardize = "standardize_cbn_interbank_rates"
    ),

    # =======================
    # Discount Rates
    # =======================
    discount_rates = list(
      id      = "cbn_discount_rates",
      aliases = c(
        "discount rates",
        "discount windows",
        "cbn discount rate"
      ),
      fetch     = list(endpoint = "GetAllDiscountRates", method = "GET"),
      frequency = "daily",
      date      = list(column = "ratedate", name = "date", format = "%d/%m/%Y"),
      group     = list(rate_type = "ratetype"),
      measures  = list(
        discount_rate = list(column = "amount", unit = "percent")
      ),
      source      = "CBN",
      standardize = "standardize_cbn_discount_rates"
    ),

    # =======================
    # NTB / Nigeria Treasury Bills
    # =======================
    ntb_cbn = list(
      id        = "cbn_ntb",
      aliases   = c("ntb", "nigeria treasury bills", "cbn ntb"),
      fetch     = list(endpoint = "GetAllSecuritiesNTB", method = "GET"),
      frequency = "daily",
      date      = list(column = "auctionDate", name = "date", format = "%d/%m/%Y"),
      group     = list(
        security_type = "securityType",
        tenor         = "tenor"
      ),
      measures  = list(
        total_subscription = list(column = "totalSubscription", unit = "million naira"),
        total_successful   = list(column = "totalSuccessful",   unit = "million naira"),
        rate               = list(column = "rate",              unit = "percent"),
        amt_offered        = list(column = "amtOffered",        unit = "million naira"),
        total_amt_repaid   = list(column = "totalAmtRepaid",    unit = "million naira"),
        net_value          = list(column = "netValue",          unit = "million naira"),
        true_yield         = list(column = "trueYield",         unit = "percent")
      ),
      source      = "CBN",
      standardize = "standardize_cbn_ntb"
    ),

    # =======================
    # FGN Bonds
    # =======================
    fgn_bond = list(
      id        = "cbn_fgn_bond",
      aliases   = c("fgn bond", "fgn bonds", "nigeria fgn bond", "cbn fgn bond"),
      fetch     = list(endpoint = "GetAllSecuritiesFGNBond", method = "GET"),
      frequency = "daily",
      date      = list(column = "auctionDate", name = "date", format = "%d/%m/%Y"),
      group     = list(
        security_type = "securityType",
        tenor         = "tenor"
      ),
      measures  = list(
        total_subscription = list(column = "totalSubscription", unit = "million naira"),
        total_successful   = list(column = "totalSuccessful",   unit = "million naira"),
        rate               = list(column = "rate",              unit = "percent"),
        amt_offered        = list(column = "amtOffered",        unit = "million naira"),
        total_amt_repaid   = list(column = "totalAmtRepaid",    unit = "million naira"),
        net_value          = list(column = "netValue",          unit = "million naira"),
        true_yield         = list(column = "trueYield",         unit = "percent")
      ),
      source      = "CBN",
      standardize = "standardize_cbn_fgn_bond"
    ),

    # =======================
    # OMO Securities
    # =======================
    omo = list(
      id        = "cbn_omo",
      aliases   = c("omo", "open market operation", "cbn omo"),
      fetch     = list(endpoint = "GetAllSecuritiesOMO", method = "GET"),
      frequency = "daily",
      date      = list(column = "auctionDate", name = "date", format = "%d/%m/%Y"),
      group     = list(
        security_type = "securityType",
        tenor         = "tenor"
      ),
      measures  = list(
        total_subscription = list(column = "totalSubscription", unit = "million naira"),
        total_successful   = list(column = "totalSuccessful",   unit = "million naira"),
        rate               = list(column = "rate",              unit = "percent"),
        amt_offered        = list(column = "amtOffered",        unit = "million naira"),
        total_amt_repaid   = list(column = "totalAmtRepaid",    unit = "million naira"),
        net_value          = list(column = "netValue",          unit = "million naira"),
        true_yield         = list(column = "trueYield",         unit = "percent")
      ),
      source      = "CBN",
      standardize = "standardize_cbn_omo"
    ),

    # =======================
    # CBN Securities / Bills
    # =======================
    cbn_sec = list(
      id        = "cbn_securities",
      aliases   = c("cbn securities", "cbn bills", "cbn certificates"),
      fetch     = list(endpoint = "GetAllSecuritiesCBNBill", method = "GET"),
      frequency = "historical",
      date      = list(column = "auctionDate", name = "date", format = "%d/%m/%Y"),
      group     = list(
        security_type = "securityType",
        tenor         = "tenor"
      ),
      measures  = list(
        total_subscription = list(column = "totalSubscription", unit = "million naira"),
        total_successful   = list(column = "totalSuccessful",   unit = "million naira"),
        rate               = list(column = "rate",              unit = "percent"),
        amt_offered        = list(column = "amtOffered",        unit = "million naira"),
        total_amt_repaid   = list(column = "totalAmtRepaid",    unit = "million naira"),
        net_value          = list(column = "netValue",          unit = "million naira"),
        true_yield         = list(column = "trueYield",         unit = "percent")
      ),
      source      = "CBN",
      standardize = "standardize_cbn_govt_securities"
    ),

    # =======================
    # Government Securities (Consolidated)
    # =======================
    securities = list(
      id        = "cbn_securities_all",
      aliases   = c(
        "securities",
        "government securities",
        "treasury bills auctions"
      ),
      fetch     = list(endpoint = "GetAllSecurities", method = "GET"),
      frequency = "daily",
      date      = list(column = "auctionDate", name = "date", format = "%d/%m/%Y"),
      measures  = list(
        amount_offered     = list(column = "amtOffered",        unit = "NGN Million"),
        total_subscription = list(column = "totalSubscription", unit = "NGN Million"),
        total_successful   = list(column = "totalSuccessful",   unit = "NGN Million"),
        stop_rate          = list(column = "rate",              unit = "percent"),
        true_yield         = list(column = "trueYield",         unit = "percent"),
        net_value          = list(column = "netValue",          unit = "NGN Million")
      ),
      source      = "CBN",
      standardize = "standardize_cbn_securities"
    ),

    # =======================
    # CBN Financial / Liquidity Operations
    # =======================
    financial_data = list(
      id        = "cbn_financial_data",
      aliases   = c(
        "financial data",
        "cbn financial data",
        "financial operations",
        "liquidity operations"
      ),
      fetch     = list(endpoint = "GetAllFinancialData", method = "GET"),
      frequency = "daily",
      date      = list(column = "recDate", name = "date"),
      measures  = list(
        opening_balance      = list(column = "opeBal",      unit = "NGN Billion"),
        rediscount_bills     = list(column = "rediscBills", unit = "NGN Billion"),
        standing_lending     = list(column = "slFacility",  unit = "NGN Billion"),
        standing_deposit     = list(column = "sdFacility",  unit = "NGN Billion"),
        repo                 = list(column = "repo",        unit = "NGN Billion"),
        reverse_repo         = list(column = "revRepo",     unit = "NGN Billion"),
        omo_sales            = list(column = "omoSales",    unit = "NGN Billion"),
        omo_repayment        = list(column = "omoRepay",    unit = "NGN Billion"),
        primary_market_sales = list(column = "pmSales",     unit = "NGN Billion"),
        primary_market_repay = list(column = "pmRepay",     unit = "NGN Billion"),
        cash_reserve_ratio   = list(column = "crr",         unit = "NGN Billion"),
        net_wdas             = list(column = "netWdas",     unit = "NGN Billion"),
        statutory_allocation = list(column = "statAlloc",   unit = "NGN Billion"),
        joint_venture_cash   = list(column = "jvCash",      unit = "NGN Billion"),
        net_clearing         = list(column = "netClr",      unit = "NGN Billion"),
        ndic_premium         = list(column = "ndicPrem",    unit = "NGN Billion"),
        other_major_flows    = list(column = "oMajor",      unit = "NGN Billion")
      ),
      source      = "CBN",
      standardize = "standardize_cbn_financial_data"
    ),

    # =======================
    # GDP by Sector -- Annual, Supply-side
    # =======================
    gdp_ng = list(
      id      = "cbn_gdp",
      aliases = c("gdp", "gdp by sector", "sectoral gdp"),
      fetch   = list(endpoint = "GetAllYearsNominalGDP", method = "GET"),
      frequency = "annual",
      date      = list(year = "tyear"),
      measures  = list(
        ## Aggregates
        gdp_basic_price   = list(column = "gdPatCurrentBasicPrices",  unit = "NGN Billion"),
        gdp_market_price  = list(column = "gdPatCurrentMarketPrices", unit = "NGN Billion"),
        net_taxes         = list(column = "netTaxesOnProducts",        unit = "NGN Billion"),
        ## Agriculture
        agriculture       = list(column = "agriculture",               unit = "NGN Billion"),
        crop_production   = list(column = "cropProduction",            unit = "NGN Billion"),
        livestock         = list(column = "livestock",                 unit = "NGN Billion"),
        forestry          = list(column = "forestry",                  unit = "NGN Billion"),
        fishing           = list(column = "fishing",                   unit = "NGN Billion"),
        ## Industry
        industry          = list(column = "industry",                  unit = "NGN Billion"),
        mining_quarrying  = list(column = "miningAndQuarrying",        unit = "NGN Billion"),
        crude_oil_gas     = list(column = "crudePetroleumAndNaturalGas", unit = "NGN Billion"),
        coal_mining       = list(column = "coalMining",                unit = "NGN Billion"),
        metal_ores        = list(column = "metalOres",                 unit = "NGN Billion"),
        other_minerals    = list(column = "quarryingAndOtherMinerals", unit = "NGN Billion"),
        ## Manufacturing
        manufacturing     = list(column = "manufacturing",             unit = "NGN Billion"),
        oil_refining      = list(column = "oilRefining",               unit = "NGN Billion"),
        cement            = list(column = "cement",                    unit = "NGN Billion"),
        food_bev_tobacco  = list(column = "foodBeverageAndTobacco",    unit = "NGN Billion"),
        textiles_footwear = list(column = "textileApparelAndFootwear", unit = "NGN Billion"),
        wood_products     = list(column = "woodAndWoodProducts",       unit = "NGN Billion"),
        pulp_paper        = list(column = "pulpPaperAndPaperProducts", unit = "NGN Billion"),
        chemicals_pharma  = list(column = "chemicalAndPharmaceuticalProducts", unit = "NGN Billion"),
        non_metallic      = list(column = "nonMetallicProducts",       unit = "NGN Billion"),
        plastics_rubber   = list(column = "plasticAndRubberProducts",  unit = "NGN Billion"),
        electronics       = list(column = "electricalAndElectronics",  unit = "NGN Billion"),
        basic_metals      = list(column = "basicMetalIronAndSteel",    unit = "NGN Billion"),
        motor_vehicles    = list(column = "motorVehiclesAndAssembly",  unit = "NGN Billion"),
        other_manufacture = list(column = "otherManufacturing",        unit = "NGN Billion"),
        ## Utilities and Construction
        electricity_gas   = list(column = "electricityGasSteamAndAirCon",  unit = "NGN Billion"),
        water_waste       = list(column = "waterSupplySewageWaste",         unit = "NGN Billion"),
        construction      = list(column = "construction",                   unit = "NGN Billion"),
        ## Services
        services          = list(column = "services",                       unit = "NGN Billion"),
        trade             = list(column = "trade",                          unit = "NGN Billion"),
        accommodation     = list(column = "accommodationAndFoodServices",   unit = "NGN Billion"),
        transport_storage = list(column = "transportationAndStorage",       unit = "NGN Billion"),
        road_transport    = list(column = "roadTransport",                  unit = "NGN Billion"),
        rail_pipeline     = list(column = "railTransportAndPipelines",      unit = "NGN Billion"),
        water_transport   = list(column = "waterTransport",                 unit = "NGN Billion"),
        air_transport     = list(column = "airTransport",                   unit = "NGN Billion"),
        transport_support = list(column = "transportServices",              unit = "NGN Billion"),
        post_courier      = list(column = "postAndCourierServices",         unit = "NGN Billion"),
        info_comm         = list(column = "informationAndCommunication",    unit = "NGN Billion"),
        telecoms          = list(column = "telecommunicationsAndInformationServices", unit = "NGN Billion"),
        publishing        = list(column = "publishing",                     unit = "NGN Billion"),
        motion_picture    = list(column = "motionPicturesSoundRecordingAndMusicProduction", unit = "NGN Billion"),
        broadcasting      = list(column = "broadcasting",                   unit = "NGN Billion"),
        arts_entertain    = list(column = "artsEntertainmentAndRecreation", unit = "NGN Billion"),
        finance_insurance = list(column = "financeAndInsurance",            unit = "NGN Billion"),
        financial_inst    = list(column = "financialInstitutions",          unit = "NGN Billion"),
        insurance         = list(column = "insurance",                      unit = "NGN Billion"),
        real_estate       = list(column = "realEstate",                     unit = "NGN Billion"),
        prof_services     = list(column = "professionalScientificAndTechnicalServices", unit = "NGN Billion"),
        admin_support     = list(column = "administrativeAndSupportServicesBusinessServices", unit = "NGN Billion"),
        public_admin      = list(column = "publicAdministration",           unit = "NGN Billion"),
        education         = list(column = "education",                      unit = "NGN Billion"),
        health_social     = list(column = "humanHealthAndSocialServices",   unit = "NGN Billion"),
        other_services    = list(column = "otherServices",                  unit = "NGN Billion")
      ),
      source      = "CBN",
      standardize = "standardize_cbn_gdp"
    ),

    # =======================
    # Nominal GDP (Quarterly, Current Basic Prices)
    # =======================
    nominal_gdp = list(
      id        = "cbn_nominal_gdp",
      aliases   = c("nominal gdp", "gdp current basic prices"),
      fetch     = list(endpoint = "GetLatestNominalGDP", method = "GET"),
      frequency = "quarterly",
      date      = list(column = "period", name = "date"),
      group     = list(year = "tyear"),
      measures  = list(
        agriculture    = list(column = "agriculture",    unit = "Billion Naira"),
        crop_production = list(column = "cropProduction", unit = "Billion Naira"),
        livestock      = list(column = "livestock",      unit = "Billion Naira"),
        forestry       = list(column = "forestry",       unit = "Billion Naira"),
        fishing        = list(column = "fishing",        unit = "Billion Naira"),
        industry       = list(column = "industry",       unit = "Billion Naira"),
        mining_quarrying = list(column = "miningAndQuarrying", unit = "Billion Naira"),
        crude_oil_gas  = list(column = "crudePetroleumAndNaturalGas", unit = "Billion Naira"),
        coal_mining    = list(column = "coalMining",     unit = "Billion Naira"),
        metal_ores     = list(column = "metalOres",      unit = "Billion Naira"),
        other_minerals = list(column = "quarryingAndOtherMinerals", unit = "Billion Naira"),
        manufacturing  = list(column = "manufacturing",  unit = "Billion Naira"),
        oil_refining   = list(column = "oilRefining",    unit = "Billion Naira"),
        cement         = list(column = "cement",         unit = "Billion Naira"),
        food_bev_tobacco = list(column = "foodBeverageAndTobacco", unit = "Billion Naira"),
        construction   = list(column = "construction",   unit = "Billion Naira"),
        services       = list(column = "services",       unit = "Billion Naira")
      ),
      source      = "CBN",
      standardize = "standardize_cbn_nominal_gdp"
    ),

    # =======================
    # International Payments
    # =======================
    international_payments = list(
      id        = "cbn_international_payments",
      aliases   = c("international payments", "int payments", "foreign payments"),
      fetch     = list(endpoint = "GetAllIntPayments", method = "GET"),
      frequency = "annual",
      date      = list(column = "payDate", name = "date"),
      measures  = list(
        letters_of_credit  = list(column = "loc",   unit = "USD Million"),
        direct_remittances = list(column = "remit", unit = "USD Million"),
        debt_service       = list(column = "debt",  unit = "USD Million"),
        total_payments     = list(column = "total", unit = "USD Million")
      ),
      source      = "CBN",
      standardize = "standardize_cbn_international_payments"
    ),

    # =======================
    # CBN Assets and Liabilities
    # =======================
    assets_liabilities = list(
      id        = "cbn_assets_liabilities",
      aliases   = c(
        "assets liabilities",
        "cbn balance sheet",
        "central bank balance sheet",
        "five year summary",
        "five year all",
        "five year (pre-1972)",
        "five year all (pre-1972)"
      ),
      fetch     = list(endpoint = "GetAllAssetsLiabilities", method = "GET"),
      frequency = "annual",
      date      = list(column = "period", name = "date"),
      measures  = list(
        ## Assets
        gold                    = list(column = "gold",       unit = "NGN Billion"),
        convertible_foreign     = list(column = "convertible", unit = "NGN Billion"),
        imf_gold                = list(column = "imfGold",    unit = "NGN Billion"),
        sdr                     = list(column = "sdr",        unit = "NGN Billion"),
        treasury_external_res   = list(column = "ter",        unit = "NGN Billion"),
        federal_govt_securities = list(column = "fgs",        unit = "NGN Billion"),
        other_securities        = list(column = "osec",       unit = "NGN Billion"),
        rediscount_advances     = list(column = "redAdv",     unit = "NGN Billion"),
        other_assets            = list(column = "otherAss",   unit = "NGN Billion"),
        fixed_assets            = list(column = "fixAss",     unit = "NGN Billion"),
        total_assets            = list(column = "totalAss",   unit = "NGN Billion"),
        ## Capital and Reserves
        paid_up_capital         = list(column = "liaCap",     unit = "NGN Billion"),
        general_reserves        = list(column = "genRes",     unit = "NGN Billion"),
        other_reserves          = list(column = "otherRes",   unit = "NGN Billion"),
        total_capital           = list(column = "totalCap",   unit = "NGN Billion"),
        ## Liabilities
        cbn_instruments         = list(column = "cbnInstruments", unit = "NGN Billion"),
        currency_in_circulation = list(column = "cinC",       unit = "NGN Billion"),
        government_deposits     = list(column = "govtDep",    unit = "NGN Billion"),
        bankers_deposits        = list(column = "bankers",    unit = "NGN Billion"),
        other_deposits          = list(column = "others",     unit = "NGN Billion"),
        total_deposits          = list(column = "totalDep",   unit = "NGN Billion"),
        other_liabilities       = list(column = "otherLia",   unit = "NGN Billion"),
        total_liabilities       = list(column = "totalLia",   unit = "NGN Billion")
      ),
      source      = "CBN",
      standardize = "standardize_cbn_assets_liabilities"
    )

  )
}
