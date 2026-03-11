# Data Sources

## What opennaijR Connects To

opennaijR does not generate data. It provides a standardised,
reproducible R interface to official data published by African
governments, central banks, and national statistics bureaus. Every
number you retrieve through the package comes directly from an
authoritative institutional source – no intermediary, no aggregator, no
third-party estimate.

The package currently connects to **21 datasets** from the Central Bank
of Nigeria. The roadmap covers the continent.

------------------------------------------------------------------------

## Current Coverage – Central Bank of Nigeria (CBN)

The CBN is the monetary authority of Nigeria and the source of some of
the most comprehensive macroeconomic data on the African continent. All
21 datasets below are accessible through
[`nga_cbn()`](https://laws2020.github.io/opennaijR/reference/nga_cbn.md).
Use
[`discover_datasets()`](https://laws2020.github.io/opennaijR/reference/discover_datasets.md)
to see the full list at any time inside your R session.

``` r
library(opennaijR)

discover_datasets()
```

------------------------------------------------------------------------

### Inflation

**Key:** `"inflation_ng"` \| **Aliases:** `"inflation"`,
`"inflation rates"` \| **Frequency:** Monthly

Nigeria’s official consumer price index measures. This is the most
commonly used dataset in opennaijR for macroeconomic research, policy
analysis, and teaching.

| Column | What it measures | Unit |
|----|----|----|
| `headline_yoy` | All-items inflation, year-on-year | Percent |
| `headline_12m` | All-items inflation, 12-month average | Percent |
| `food_yoy` | Food inflation, year-on-year | Percent |
| `food_12m` | Food inflation, 12-month average | Percent |
| `core_ex_farm_yoy` | Core inflation ex-farm produce, year-on-year | Percent |
| `core_ex_farm_12m` | Core inflation ex-farm produce, 12-month average | Percent |
| `core_ex_farm_energy_yoy` | Core ex-farm and energy, year-on-year | Percent |
| `core_ex_farm_energy_12m` | Core ex-farm and energy, 12-month average | Percent |

``` r
infl <- nga_cbn("inflation", auto.assign = FALSE)
```

------------------------------------------------------------------------

### Exchange Rates (Official)

**Key:** `"exchange_rates"` \| **Aliases:** `"forex rates"`,
`"cbn fx rates"` \| **Frequency:** Daily

Official CBN exchange rates for all traded currencies. Each row is one
currency on one date.

| Column         | What it measures                  | Unit |
|----------------|-----------------------------------|------|
| `currency`     | Currency pair (grouping variable) | –    |
| `buying_rate`  | CBN official buying rate          | NGN  |
| `central_rate` | CBN central rate                  | NGN  |
| `selling_rate` | CBN official selling rate         | NGN  |

``` r
exch <- nga_cbn("exchange_rates", auto.assign = FALSE)
```

------------------------------------------------------------------------

### NFEM Exchange Rates

**Key:** `"nfem_exchange_rates"` \| **Aliases:** `"nfem"` \|
**Frequency:** Daily

Nigerian Foreign Exchange Market (NFEM) rates – the market-determined
window rates published daily by the CBN.

| Column         | What it measures           | Unit  |
|----------------|----------------------------|-------|
| `closing`      | Closing NFEM rate          | NGN   |
| `high`         | Highest rate of the day    | NGN   |
| `low`          | Lowest rate of the day     | NGN   |
| `weighted_avg` | Weighted average rate      | NGN   |
| `simple_avg`   | Simple average rate        | NGN   |
| `deals`        | Number of deals transacted | Count |

------------------------------------------------------------------------

### Monthly Average Exchange Rates

**Key:** `"monthly_avg_exchange_rates"` \| **Aliases:**
`"monthly average exchange rate"`, `"average exchange"` \|
**Frequency:** Monthly

Monthly averaged rates for major currency pairs.

| Column        | What it measures                 | Unit    |
|---------------|----------------------------------|---------|
| `ifem_dollar` | IFEM USD/NGN average             | NGN/USD |
| `bdc_dollar`  | Bureau de Change USD/NGN average | NGN/USD |
| `pounds`      | GBP/NGN average                  | NGN/GBP |
| `euro`        | EUR/NGN average                  | NGN/EUR |
| `cfa_franc`   | CFA franc/NGN average            | NGN/CFA |

------------------------------------------------------------------------

### Crude Oil Prices

**Key:** `"crude_oil"` \| **Aliases:** `"crude oil"`, `"oil price"`,
`"bonny light"` \| **Frequency:** Monthly

Nigeria’s Bonny Light crude oil price alongside production and export
volumes.

| Column                | What it measures          | Unit                |
|-----------------------|---------------------------|---------------------|
| `price_bonny_light`   | Bonny Light spot price    | USD/barrel          |
| `domestic_production` | Domestic crude production | Million barrels/day |
| `crude_oil_export`    | Crude oil exports         | Million barrels/day |

``` r
oil <- nga_cbn("crude_oil", auto.assign = FALSE)
```

------------------------------------------------------------------------

### Daily Crude Oil Prices

**Key:** `"daily_crude_oil"` \| **Aliases:** `"daily crude oil"`,
`"bonny light daily"` \| **Frequency:** Daily

Daily Bonny Light price postings for higher-frequency analysis.

| Column              | What it measures        | Unit       |
|---------------------|-------------------------|------------|
| `price_bonny_light` | Daily Bonny Light price | USD/barrel |

------------------------------------------------------------------------

### External Reserves

**Key:** `"external_reserves"` \| **Aliases:** `"external reserves"`,
`"cbn reserves"`, `"exr"` \| **Frequency:** Daily

Nigeria’s gross and liquid foreign exchange reserve position, published
daily.

| Column               | What it measures          | Unit    |
|----------------------|---------------------------|---------|
| `gross_reserves`     | Total gross reserves      | USD     |
| `liquid_reserves`    | Liquid (usable) reserves  | USD     |
| `blocked_reserves`   | Blocked reserves          | USD     |
| `blocked_percentage` | Blocked as share of gross | Percent |

------------------------------------------------------------------------

### Foreign Exchange Reserves (Monthly)

**Key:** `"fx_reserves"` \| **Aliases:** `"fx reserves"`,
`"forex reserves"` \| **Frequency:** Monthly

Monthly reserve position. Complements the daily `external_reserves`
series when monthly aggregates are sufficient.

| Column             | What it measures          | Unit        |
|--------------------|---------------------------|-------------|
| `total_reserves`   | Gross total reserves      | USD Million |
| `liquid_reserves`  | Liquid reserves           | USD Million |
| `blocked_reserves` | Blocked reserves          | USD Million |
| `blocked_percent`  | Blocked as share of total | Percent     |

------------------------------------------------------------------------

### Money and Credit Statistics

**Key:** `"money_credit"` \| **Aliases:** `"money supply"`,
`"monetary aggregates"`, `"credit statistics"` \| **Frequency:** Monthly

The full monetary survey – money supply aggregates, credit flows, and
the monetary base. Essential for monetary policy research.

| Column | What it measures | Unit |
|----|----|----|
| `broad_money_m3` | Broad money M3 | NGN Billion |
| `money_supply_m2` | Money supply M2 | NGN Billion |
| `narrow_money` | Narrow money M1 | NGN Billion |
| `quasi_money` | Quasi money | NGN Billion |
| `currency_outside_banks` | Currency held outside banking system | NGN Billion |
| `currency_in_circulation` | Total currency in circulation | NGN Billion |
| `bank_reserves` | Bank reserves at CBN | NGN Billion |
| `base_money` | Monetary base | NGN Billion |
| `net_foreign_assets` | Net foreign assets | NGN Billion |
| `net_domestic_assets` | Net domestic assets | NGN Billion |
| `credit_to_government` | Credit to government sector | NGN Billion |
| `credit_to_private_sector` | Credit to private sector | NGN Billion |

``` r
money <- nga_cbn("money_credit", auto.assign = FALSE)
```

------------------------------------------------------------------------

### Money Market Indicators

**Key:** `"money_market"` \| **Aliases:** `"interest rates"`,
`"cbn policy rates"` \| **Frequency:** Monthly

CBN policy rates and money market interest rates – the Monetary Policy
Rate (MPR), treasury bill rate, lending and deposit rates.

| Column                    | What it measures          | Unit    |
|---------------------------|---------------------------|---------|
| `monetary_policy_rate`    | CBN MPR                   | Percent |
| `minimum_rediscount_rate` | Minimum Rediscount Rate   | Percent |
| `interbank_call_rate`     | Interbank call rate       | Percent |
| `treasury_bill_rate`      | 91-day treasury bill rate | Percent |
| `savings_deposit_rate`    | Savings deposit rate      | Percent |
| `prime_lending_rate`      | Prime lending rate        | Percent |
| `maximum_lending_rate`    | Maximum lending rate      | Percent |
| `deposit_1m_rate`         | 1-month deposit rate      | Percent |
| `deposit_3m_rate`         | 3-month deposit rate      | Percent |
| `deposit_6m_rate`         | 6-month deposit rate      | Percent |
| `deposit_12m_rate`        | 12-month deposit rate     | Percent |

``` r
mkt <- nga_cbn("money_market", auto.assign = FALSE)
```

------------------------------------------------------------------------

### Interbank Rates

**Key:** `"interbank_rates"` \| **Aliases:** `"inter-bank rates"`,
`"obb rate"`, `"weighted average interbank rate"` \| **Frequency:**
Daily

Daily interbank lending rates by rate type – Open Buy Back (OBB),
overnight, and weighted averages.

| Column             | What it measures                  | Unit    |
|--------------------|-----------------------------------|---------|
| `rate_type`        | Rate category (grouping variable) | –       |
| `range`            | Rate range for the day            | Percent |
| `weighted_average` | Weighted average rate             | Percent |

------------------------------------------------------------------------

### Discount Rates

**Key:** `"discount_rates"` \| **Aliases:** `"discount windows"`,
`"cbn discount rate"` \| **Frequency:** Daily

CBN discount window rates by rate type.

| Column          | What it measures                | Unit    |
|-----------------|---------------------------------|---------|
| `rate_type`     | Window type (grouping variable) | –       |
| `discount_rate` | Discount rate                   | Percent |

------------------------------------------------------------------------

### Nigeria Treasury Bills (NTB)

**Key:** `"ntb_cbn"` \| **Aliases:** `"ntb"`, `"nigeria treasury bills"`
\| **Frequency:** Auction dates

Results of CBN treasury bill auctions – amounts offered, subscriptions,
stop rates, and true yields.

| Column               | What it measures              | Unit        |
|----------------------|-------------------------------|-------------|
| `security_type`      | Bill type (grouping variable) | –           |
| `tenor`              | Maturity tenor                | –           |
| `amt_offered`        | Amount offered at auction     | NGN Million |
| `total_subscription` | Total subscriptions received  | NGN Million |
| `total_successful`   | Total successful bids         | NGN Million |
| `rate`               | Stop / cut-off rate           | Percent     |
| `true_yield`         | True yield                    | Percent     |
| `net_value`          | Net value                     | NGN Million |
| `total_amt_repaid`   | Total amount repaid           | NGN Million |

------------------------------------------------------------------------

### FGN Bonds

**Key:** `"fgn_bond"` \| **Aliases:** `"fgn bond"`, `"fgn bonds"`,
`"nigeria fgn bond"` \| **Frequency:** Auction dates

Federal Government of Nigeria bond auction results – the primary market
for long-dated government debt. Columns mirror the NTB auction
structure, grouped by `security_type` and `tenor`.

------------------------------------------------------------------------

### OMO Securities

**Key:** `"omo"` \| **Aliases:** `"omo"`, `"open market operation"` \|
**Frequency:** Auction dates

Open Market Operation bill auction results – the CBN’s primary tool for
managing banking system liquidity. Columns mirror the NTB auction
structure.

------------------------------------------------------------------------

### CBN Securities

**Key:** `"cbn_sec"` \| **Aliases:** `"cbn securities"`, `"cbn bills"`,
`"cbn certificates"` \| **Frequency:** Historical

CBN-issued bill auction results. Columns mirror the NTB auction
structure.

------------------------------------------------------------------------

### Government Securities (Consolidated)

**Key:** `"securities"` \| **Aliases:** `"government securities"`,
`"treasury bills auctions"` \| **Frequency:** Auction dates

A consolidated view of all government security auctions – NTB, FGN
Bonds, OMO, and CBN Bills in a single dataset.

| Column               | What it measures      | Unit        |
|----------------------|-----------------------|-------------|
| `amount_offered`     | Amount offered        | NGN Million |
| `total_subscription` | Total subscriptions   | NGN Million |
| `total_successful`   | Total successful bids | NGN Million |
| `stop_rate`          | Stop / cut-off rate   | Percent     |
| `true_yield`         | True yield            | Percent     |
| `net_value`          | Net value             | NGN Million |

------------------------------------------------------------------------

### CBN Financial and Liquidity Operations

**Key:** `"financial_data"` \| **Aliases:** `"financial data"`,
`"liquidity operations"` \| **Frequency:** Daily

Daily CBN balance sheet liquidity flows – the operational detail behind
monetary policy implementation. Covers standing facilities, repo, OMO,
CRR, and statutory allocations.

| Column                 | What it measures           | Unit        |
|------------------------|----------------------------|-------------|
| `opening_balance`      | Opening system balance     | NGN Billion |
| `standing_lending`     | Standing Lending Facility  | NGN Billion |
| `standing_deposit`     | Standing Deposit Facility  | NGN Billion |
| `repo`                 | Repo operations            | NGN Billion |
| `reverse_repo`         | Reverse repo operations    | NGN Billion |
| `omo_sales`            | OMO sales                  | NGN Billion |
| `omo_repayment`        | OMO repayments             | NGN Billion |
| `cash_reserve_ratio`   | CRR debits                 | NGN Billion |
| `statutory_allocation` | FAAC statutory allocations | NGN Billion |
| `net_clearing`         | Net clearing               | NGN Billion |

------------------------------------------------------------------------

### GDP by Sector (Annual, Supply-side)

**Key:** `"gdp_ng"` \| **Aliases:** `"gdp"`, `"gdp by sector"`,
`"sectoral gdp"` \| **Frequency:** Annual

Annual nominal GDP broken down by sector at current basic prices – the
most granular sectoral breakdown available from the CBN. Covers
agriculture, industry, manufacturing, utilities, construction, and all
services sub-sectors.

Major aggregate columns:

| Column              | What it measures                | Unit        |
|---------------------|---------------------------------|-------------|
| `gdp_basic_price`   | GDP at current basic prices     | NGN Billion |
| `gdp_market_price`  | GDP at current market prices    | NGN Billion |
| `agriculture`       | Agricultural sector total       | NGN Billion |
| `industry`          | Industrial sector total         | NGN Billion |
| `manufacturing`     | Manufacturing sub-sector        | NGN Billion |
| `services`          | Services sector total           | NGN Billion |
| `construction`      | Construction                    | NGN Billion |
| `crude_oil_gas`     | Crude petroleum and natural gas | NGN Billion |
| `finance_insurance` | Finance and insurance           | NGN Billion |
| `telecoms`          | Telecommunications              | NGN Billion |

``` r
gdp <- nga_cbn("gdp_ng", auto.assign = FALSE)
```

------------------------------------------------------------------------

### Nominal GDP (Quarterly)

**Key:** `"nominal_gdp"` \| **Aliases:** `"nominal gdp"`,
`"gdp current basic prices"` \| **Frequency:** Quarterly

Quarterly nominal GDP at current basic prices with sectoral breakdown.
Complements `gdp_ng` for higher-frequency GDP analysis.

------------------------------------------------------------------------

### International Payments

**Key:** `"international_payments"` \| **Aliases:** `"int payments"`,
`"foreign payments"` \| **Frequency:** Annual

Nigeria’s international payment flows – letters of credit, remittances,
and debt service.

| Column               | What it measures               | Unit        |
|----------------------|--------------------------------|-------------|
| `letters_of_credit`  | Letters of credit issued       | USD Million |
| `direct_remittances` | Direct remittances             | USD Million |
| `debt_service`       | External debt service payments | USD Million |
| `total_payments`     | Total international payments   | USD Million |

------------------------------------------------------------------------

### CBN Assets and Liabilities

**Key:** `"assets_liabilities"` \| **Aliases:** `"cbn balance sheet"`,
`"central bank balance sheet"` \| **Frequency:** Annual

The CBN’s full balance sheet – assets (gold, foreign reserves,
government securities, advances) and liabilities (capital, deposits,
currency in circulation) going back to the pre-1972 historical series.

| Column                    | What it measures                | Unit        |
|---------------------------|---------------------------------|-------------|
| `total_assets`            | Total CBN assets                | NGN Billion |
| `gold`                    | Gold holdings                   | NGN Billion |
| `convertible_foreign`     | Convertible foreign assets      | NGN Billion |
| `federal_govt_securities` | FGN securities held             | NGN Billion |
| `currency_in_circulation` | Currency in circulation         | NGN Billion |
| `government_deposits`     | Government deposits at CBN      | NGN Billion |
| `bankers_deposits`        | Commercial bank deposits at CBN | NGN Billion |
| `total_liabilities`       | Total CBN liabilities           | NGN Billion |

------------------------------------------------------------------------

## Complete Dataset Index

``` r
# See all datasets with keys and descriptions
discover_datasets()
```

| Key | Description | Frequency |
|----|----|----|
| `inflation_ng` | Consumer price inflation | Monthly |
| `exchange_rates` | Official exchange rates (all currencies) | Daily |
| `nfem_exchange_rates` | NFEM market rates | Daily |
| `monthly_avg_exchange_rates` | Monthly average exchange rates | Monthly |
| `crude_oil` | Bonny Light price and production | Monthly |
| `daily_crude_oil` | Daily Bonny Light price | Daily |
| `external_reserves` | External reserves position | Daily |
| `fx_reserves` | Foreign exchange reserves | Monthly |
| `money_credit` | Money supply and credit aggregates | Monthly |
| `money_market` | Policy and money market rates | Monthly |
| `interbank_rates` | Daily interbank rates | Daily |
| `discount_rates` | CBN discount window rates | Daily |
| `ntb_cbn` | Nigeria Treasury Bill auctions | Auction dates |
| `fgn_bond` | FGN Bond auctions | Auction dates |
| `omo` | Open Market Operation auctions | Auction dates |
| `cbn_sec` | CBN Bill auctions | Historical |
| `securities` | All government securities (consolidated) | Auction dates |
| `financial_data` | CBN liquidity operations | Daily |
| `gdp_ng` | Annual GDP by sector | Annual |
| `nominal_gdp` | Quarterly nominal GDP | Quarterly |
| `international_payments` | International payment flows | Annual |
| `assets_liabilities` | CBN balance sheet | Annual |

------------------------------------------------------------------------

## Data Principles

**Official sources only.** Every dataset is retrieved directly from the
CBN’s own data infrastructure. No third-party aggregators, scraped
mirrors, or unofficial compilations are used.

**No manipulation of values.** opennaijR does not alter statistical
figures. All transformations are limited to cleaning column names,
parsing dates, and reshaping to tidy format.

**Full reproducibility.** Every retrieval is scriptable and produces the
same result when run against the same source publication.

**Attribution.** Data remains the intellectual property of the Central
Bank of Nigeria. Users should cite the CBN as the data source in
published academic or professional work, not opennaijR.

------------------------------------------------------------------------

## Nigeria Expansion Roadmap

Additional Nigerian institutions targeted for connection:

**National Bureau of Statistics (NBS)** – Consumer Price Index at state
level, quarterly and annual GDP, labour force statistics, trade data,
and poverty indicators. The NBS is the primary source for subnational
and household-level analysis.

**Nigerian Exchange Group (NGX)** – Equity prices, market indices,
trading volumes, and corporate actions for publicly listed companies.

------------------------------------------------------------------------

## Africa Expansion Roadmap

When Nigerian coverage is complete, opennaijR will expand to central
banks and statistics bureaus across Africa following the same
`country_code_institution` naming convention:

**West Africa:** Bank of Ghana (`gha_bog`), BCEAO covering eight CFA
franc countries (`xof_bceao`).

**East Africa:** Central Bank of Kenya (`ken_cbk`), Bank of Tanzania
(`tza_bot`), Bank of Uganda (`uga_bou`), National Bank of Rwanda
(`rwa_bnr`).

**Southern Africa:** South African Reserve Bank (`zaf_sarb`), Bank of
Zambia (`zmb_boz`).

**North Africa:** Central Bank of Egypt (`egy_cbe`), Bank Al-Maghrib
Morocco (`mar_bam`).

See the Contributing article if you have knowledge of any of these
sources and would like to help build a connector.
