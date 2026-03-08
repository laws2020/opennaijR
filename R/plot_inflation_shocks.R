#' Plot Inflation with Macroeconomic Shocks
#' @param data A data frame containing inflation data
#' @param date_col The name of the date column (default: "date")
#' @param val_col The name of the inflation value column (default: "headline_yoy")
#' @param title The plot title
#' @importFrom graphics par rect abline text
#' @export
plot_inflation_shocks <- function(data,
                                  date_col = "date",
                                  val_col = "headline_yoy",
                                  title = "Nigeria Headline Inflation (Year-on-Year)") {

  # 1. Setup Data
  df <- data
  df$x <- as.Date(df[[date_col]])
  df$y <- as.numeric(df[[val_col]])
  df <- df[!is.na(df$x) & !is.na(df$y), ] # Remove NAs for plotting

  # 2. Define Key Event Dates
  events <- list(
    recession_start = as.Date("2016-03-01"),
    recession_end   = as.Date("2017-03-01"),
    covid           = as.Date("2020-03-01"),
    subsidy         = as.Date("2023-05-29")
  )

  # 3. Identify Peak & Trough
  p_idx <- which.max(df$y)
  t_idx <- which.min(df$y)

  # 4. Base Plot
  par(mar = c(6, 5, 4, 4), las = 1, family = "sans")

  plot(df$x, df$y, type = "l", lwd = 2.5, col = "#1F4E79",
       xlab = "", ylab = "Inflation Rate (%)", main = title,
       bty = "l", xaxt = "n")

  # Custom X-Axis
  axis.Date(1, at = seq(min(df$x), max(df$x), by = "2 years"), format = "%Y")
  grid(col = "gray90", lty = "dotted")

  # 5. Add Shocks & Highlights
  # Shade 2016 Recession
  rect(events$recession_start, par("usr")[3], events$recession_end, par("usr")[4],
       col = rgb(0.8, 0.8, 0.8, 0.3), border = NA)

  # Vertical Lines (COVID & Subsidy)
  abline(v = c(events$covid, events$subsidy), col = c("#B22222", "#8B0000"),
         lwd = 1.5, lty = c(2, 3))

  # Labels
  text(events$covid, max(df$y), "COVID-19", pos = 2, col = "#B22222", cex = 0.7, font = 2)
  text(events$subsidy, max(df$y) * 0.9, "Subsidy Removal", pos = 2, col = "#8B0000", cex = 0.7, font = 2)

  # Peak & Trough Points
  points(c(df$x[p_idx], df$x[t_idx]), c(df$y[p_idx], df$y[t_idx]),
         pch = 21, bg = c("#FF8C00", "#228B22"), cex = 1.5)

  # 6. Source & Annotations
  mtext("Source: opennaijR | NBS/CBN", side = 1, line = 4, adj = 0, cex = 0.7, col = "gray40")

  # Current Value Label
  text(tail(df$x, 1), tail(df$y, 1), paste0(" ", round(tail(df$y, 1), 1), "%"),
       pos = 4, col = "#1F4E79", font = 2, cex = 0.8)
}
