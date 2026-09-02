# =============================================================================
# 05_figures_forest_plots.R
# Regional aggregate meta-analysis, Central Asia:
#   Figure 1 — H. pylori prevalence
#   Figure 2 — clarithromycin resistance
#   plus tidy summary + per-study tables for every outcome.
# Author: K. Dauyey
# Pipeline step 5 of 5.  Run from the repository root.
#
# INPUT : data/meta/CentralAsia_Hpylori_Prevalence.csv   (tracked in-repo)
#         data/meta/CentralAsia_Hpylori_Resistance.csv   (tracked in-repo)
#         (aggregate figures from published studies; provenance in data/meta/README.md)
# OUTPUT: results/meta-analysis/
#         ├── Figure1_ForestPlot_Hpylori_Prevalence.pdf
#         ├── Figure2_ForestPlot_Clarithromycin_Resistance.pdf
#         ├── Table_Prevalence_Summary.csv        (overall + by diagnostic method)
#         ├── Table_Prevalence_PerStudy.csv
#         ├── Table_Resistance_Summary.csv        (CLR / MTZ / AMX, when k >= 2)
#         └── Table_Clarithromycin_PerStudy.csv
#
# Freeman-Tukey double-arcsine transform (sm = "PFT"), random-effects model.
# High heterogeneity is expected across mixed diagnostic methods; pooled
# estimates are interpreted as regional indicators, not point prevalence.
# =============================================================================

rm(list = ls())

library(here)
library(readr)
library(meta)
library(metafor)

prev_path <- here("data", "meta", "CentralAsia_Hpylori_Prevalence.csv")
res_path  <- here("data", "meta", "CentralAsia_Hpylori_Resistance.csv")
for (p in c(prev_path, res_path)) {
  if (!file.exists(p)) stop("Missing input: ", p, "\nSee data/meta/README.md.")
}

prevalence <- read_csv(prev_path, show_col_types = FALSE)
resistance <- read_csv(res_path,  show_col_types = FALSE)

out_dir <- here("results", "meta-analysis")
dir.create(out_dir, recursive = TRUE, showWarnings = FALSE)

# -----------------------------------------------------------------------------
# Helper: one-row Freeman-Tukey random-effects summary on the proportion scale
# -----------------------------------------------------------------------------
ft_summary <- function(events, n, label) {
  ok <- !is.na(events) & !is.na(n) & n > 0
  events <- events[ok]; n <- n[ok]
  k <- length(events)
  if (k < 2) {
    return(data.frame(Outcome = label, k = k, Pooled_prop = NA_real_,
                      CI_low = NA_real_, CI_high = NA_real_, PI_low = NA_real_,
                      PI_high = NA_real_, I2_pct = NA_real_, tau2 = NA_real_,
                      Q = NA_real_, df = NA_integer_, p_Q = NA_character_))
  }
  dat <- escalc(measure = "PFT", xi = events, ni = n)
  res <- rma(yi, vi, data = dat, method = "REML")
  pr  <- predict(res, transf = transf.ipft.hm, targs = list(ni = n))
  data.frame(
    Outcome     = label,
    k           = k,
    Pooled_prop = round(pr$pred, 4),
    CI_low      = round(pr$ci.lb, 4),
    CI_high     = round(pr$ci.ub, 4),
    PI_low      = round(pr$pi.lb, 4),
    PI_high     = round(pr$pi.ub, 4),
    I2_pct      = round(res$I2, 1),
    tau2        = round(res$tau2, 4),
    Q           = round(res$QE, 2),
    df          = res$k - res$p,
    p_Q         = formatC(res$QEp, format = "e", digits = 2)
  )
}

# -----------------------------------------------------------------------------
# Helper: per-study back-transformed proportion + 95% CI
# -----------------------------------------------------------------------------
per_study <- function(df, events, n) {
  d <- escalc(measure = "PFT", xi = events, ni = n)
  s <- summary(d, transf = transf.ipft, ni = n)
  data.frame(
    df,
    Prop   = round(s$yi, 4),
    CI_low  = round(s$ci.lb, 4),
    CI_high = round(s$ci.ub, 4)
  )
}

# =============================================================================
# Figure 1 + prevalence tables
# =============================================================================
meta_prev <- metaprop(
  event   = Positive,
  n       = N,
  data    = prevalence,
  studlab = paste0(prevalence$Author_Year, " [",
                   prevalence$Country, " - ",
                   prevalence$Diagnostic_Method, "]"),
  sm      = "PFT",
  method  = "Inverse",
  random  = TRUE
)

pdf(file.path(out_dir, "Figure1_ForestPlot_Hpylori_Prevalence.pdf"),
    width = 10, height = 6)
forest(meta_prev,
       xlab        = "H. pylori prevalence (%)",
       leftcols    = "studlab",
       leftlabs    = "Study [Country - Method]",
       rightlabs   = c("Prevalence", "95% CI"),
       col.diamond = "blue",
       print.I2    = TRUE,
       print.tau2  = FALSE)
dev.off()

# Overall + subgroup-by-method summary
prev_summ <- ft_summary(prevalence$Positive, prevalence$N, "Prevalence (overall)")
for (mth in sort(unique(prevalence$Diagnostic_Method))) {
  s <- prevalence[prevalence$Diagnostic_Method == mth, ]
  prev_summ <- rbind(prev_summ,
                     ft_summary(s$Positive, s$N, paste0("Prevalence [", mth, "]")))
}
write_csv(prev_summ, file.path(out_dir, "Table_Prevalence_Summary.csv"))

prev_ps <- per_study(
  prevalence[, c("Country", "Author_Year", "Diagnostic_Method", "N", "Positive")],
  prevalence$Positive, prevalence$N
)
prev_ps$Weight_random_pct <- round(100 * meta_prev$w.random / sum(meta_prev$w.random), 1)
write_csv(prev_ps, file.path(out_dir, "Table_Prevalence_PerStudy.csv"))

# =============================================================================
# Figure 2 + resistance tables
# =============================================================================
cla_event <- round(resistance[["Clarithromycin_Res_%"]] *
                     resistance[["N_Isolates"]] / 100)

meta_cla <- metaprop(
  event   = cla_event,
  n       = resistance[["N_Isolates"]],
  data    = resistance,
  studlab = resistance$Author_Year,
  sm      = "PFT",
  random  = TRUE
)

pdf(file.path(out_dir, "Figure2_ForestPlot_Clarithromycin_Resistance.pdf"),
    width = 10, height = 6)
forest(meta_cla,
       xlab        = "Clarithromycin resistance (%)",
       col.diamond = "firebrick")
dev.off()

res_summ <- rbind(
  ft_summary(cla_event, resistance[["N_Isolates"]], "Clarithromycin resistance"),
  ft_summary(round(resistance[["Metronidazole_Res_%"]] * resistance[["N_Isolates"]] / 100),
             resistance[["N_Isolates"]], "Metronidazole resistance"),
  ft_summary(round(resistance[["Amoxicillin_Res_%"]] * resistance[["N_Isolates"]] / 100),
             resistance[["N_Isolates"]], "Amoxicillin resistance")
)
write_csv(res_summ, file.path(out_dir, "Table_Resistance_Summary.csv"))

cla_ps <- per_study(
  resistance[, c("Country", "Author_Year", "N_Isolates", "Clarithromycin_Res_%")],
  cla_event, resistance[["N_Isolates"]]
)
cla_ps$Weight_random_pct <- round(100 * meta_cla$w.random / sum(meta_cla$w.random), 1)
write_csv(cla_ps, file.path(out_dir, "Table_Clarithromycin_PerStudy.csv"))

message("Wrote 2 figures + 4 tables to ", out_dir)
print(prev_summ[1, ])
print(res_summ)
