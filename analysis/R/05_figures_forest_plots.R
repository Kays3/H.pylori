# =============================================================================
# 05_figures_forest_plots.R
# Figure 1 (H. pylori prevalence) and Figure 2 (clarithromycin resistance)
# Regional aggregate meta-analysis, Central Asia.
# Author: K. Dauyey
# Pipeline step 5 of 5.  Run from the repository root.
#
# INPUT : data/raw/CentralAsia_Hpylori_Prevalence.csv
#         data/raw/CentralAsia_Hpylori_Resistance.csv
#         (manual extraction from published studies; schema in data/README.md)
# OUTPUT: results/figures/Figure1_ForestPlot_Hpylori_Prevalence.pdf
#         results/figures/Figure2_ForestPlot_Clarithromycin_Resistance.pdf
#
# Freeman-Tukey double-arcsine transform (sm = "PFT"), random-effects model.
# High heterogeneity is expected across mixed diagnostic methods; pooled
# estimates are interpreted as regional indicators, not point prevalence.
# =============================================================================

rm(list = ls())

library(here)
library(readr)
library(meta)

prev_path <- here("data", "raw", "CentralAsia_Hpylori_Prevalence.csv")
res_path  <- here("data", "raw", "CentralAsia_Hpylori_Resistance.csv")
for (p in c(prev_path, res_path)) {
  if (!file.exists(p)) stop("Missing input: ", p, "\nSee data/README.md.")
}

prevalence <- read_csv(prev_path, show_col_types = FALSE)
resistance <- read_csv(res_path,  show_col_types = FALSE)

out_fig <- here("results", "figures")
dir.create(out_fig, recursive = TRUE, showWarnings = FALSE)

# --- Figure 1: prevalence ----------------------------------------------------
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

pdf(file.path(out_fig, "Figure1_ForestPlot_Hpylori_Prevalence.pdf"),
    width = 10, height = 6)
forest(meta_prev,
       xlab       = "H. pylori prevalence (%)",
       leftcols   = "studlab",
       leftlabs   = "Study [Country - Method]",
       rightlabs  = c("Prevalence", "95% CI"),
       col.diamond = "blue",
       print.I2   = TRUE,
       print.tau2 = FALSE)
dev.off()

# --- Figure 2: clarithromycin resistance -----------------------------------
meta_cla <- metaprop(
  event   = round(resistance[["Clarithromycin_Res_%"]] *
                    resistance[["N_Isolates"]] / 100),
  n       = resistance[["N_Isolates"]],
  data    = resistance,
  studlab = resistance$Author_Year,
  sm      = "PFT",
  random  = TRUE
)

pdf(file.path(out_fig, "Figure2_ForestPlot_Clarithromycin_Resistance.pdf"),
    width = 10, height = 6)
forest(meta_cla,
       xlab        = "Clarithromycin resistance (%)",
       col.diamond = "firebrick")
dev.off()

message("Wrote Figure 1 and Figure 2 to ", out_fig)

# --- Optional: metronidazole / amoxicillin -------------------------------------
# Uncomment when those columns are populated for enough studies.
# meta_mtz <- metaprop(
#   event = round(resistance[["Metronidazole_Res_%"]] * resistance[["N_Isolates"]] / 100),
#   n = resistance[["N_Isolates"]], data = resistance,
#   studlab = resistance$Author_Year, sm = "PFT", random = TRUE)
# meta_amx <- metaprop(
#   event = round(resistance[["Amoxicillin_Res_%"]] * resistance[["N_Isolates"]] / 100),
#   n = resistance[["N_Isolates"]], data = resistance,
#   studlab = resistance$Author_Year, sm = "PFT", random = TRUE)
