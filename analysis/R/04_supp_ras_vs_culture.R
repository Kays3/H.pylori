# =============================================================================
# 04_supp_ras_vs_culture.R
# Supplementary — diagnostic performance of RAS vs culture for H. pylori
# Author: K. Dauyey
# Pipeline step 4 of 5.  Run from the repository root.
#
# INPUT : data/processed/kazakhstan_cohort_clean.csv   (from 00_clean_data.R)
# OUTPUT: results/tables/SuppTable_RAS_vs_Culture_Performance.html
#         results/figures/SuppFig_ROC_RAS_vs_Culture.pdf
#
# Culture is treated as the reference standard purely for this 2x2 comparison.
# Note (per peer review): long-distance sample transport reduces culture
# viability, so discordance is expected and is discussed in the manuscript
# rather than read as RAS error.
# =============================================================================

rm(list = ls())

library(here)
library(readr)
library(dplyr)
library(gt)
library(pROC)
library(ggplot2)

df <- read_csv(here("data", "processed", "kazakhstan_cohort_clean.csv"),
               show_col_types = FALSE)

df_test <- df %>% filter(!is.na(RAS_result) & !is.na(Culture))

conf <- df_test %>%
  mutate(RAS_pos = RAS_result == "Positive",
         Cul_pos = Culture    == "Positive") %>%
  summarise(
    TP = sum( RAS_pos &  Cul_pos),
    FP = sum( RAS_pos & !Cul_pos),
    TN = sum(!RAS_pos & !Cul_pos),
    FN = sum(!RAS_pos &  Cul_pos)
  ) %>%
  mutate(
    Sensitivity = TP / (TP + FN),
    Specificity = TN / (TN + FP),
    Accuracy    = (TP + TN) / (TP + TN + FP + FN),
    PPV         = TP / (TP + FP),
    NPV         = TN / (TN + FN)
  )

print(conf)

perf_gt <- conf %>%
  transmute(
    TP, FP, TN, FN,
    Sensitivity = round(Sensitivity, 3),
    Specificity = round(Specificity, 3),
    Accuracy    = round(Accuracy, 3),
    PPV         = round(PPV, 3),
    NPV         = round(NPV, 3)
  ) %>%
  gt() %>%
  tab_header(title = md("**Performance of RAS vs. culture for *H. pylori* detection**"))

out_tab <- here("results", "tables")
out_fig <- here("results", "figures")
dir.create(out_tab, recursive = TRUE, showWarnings = FALSE)
dir.create(out_fig, recursive = TRUE, showWarnings = FALSE)
gtsave(perf_gt, file.path(out_tab, "SuppTable_RAS_vs_Culture_Performance.html"))

# --- ROC -----------------------------------------------------------------------
df_roc <- df_test %>%
  mutate(RAS_numeric   = as.integer(RAS_result == "Positive"),
         Culture_binary = as.integer(Culture   == "Positive"))

roc_obj <- roc(df_roc$Culture_binary, df_roc$RAS_numeric, quiet = TRUE)
message("AUC: ", round(as.numeric(auc(roc_obj)), 3))

p <- ggroc(roc_obj, legacy.axes = TRUE) +
  geom_abline(linetype = "dashed", colour = "grey60") +
  annotate("text", x = 0.6, y = 0.1,
           label = paste("AUC =", round(as.numeric(auc(roc_obj)), 3)), size = 5) +
  labs(title = "ROC: RAS vs. culture for H. pylori detection",
       x = "1 - Specificity", y = "Sensitivity") +
  theme_minimal()

ggsave(file.path(out_fig, "SuppFig_ROC_RAS_vs_Culture.pdf"),
       p, width = 6, height = 5)
message("Wrote table + ROC figure to results/")
