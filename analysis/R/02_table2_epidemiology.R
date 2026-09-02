# =============================================================================
# 02_table2_epidemiology.R
# Table 2 — baseline characteristics by H. pylori culture result
# Author: K. Dauyey
# Pipeline step 2 of 5.  Run from the repository root.
#
# INPUT : data/processed/kazakhstan_cohort_clean.csv   (from 00_clean_data.R)
# OUTPUT: results/tables/Table2_Hpylori_Epidemiology.html
#
# Cohort = patients with both Endoscopy and Culture recorded.
# Continuous: mean +/- SD ; categorical: n (%) ; group comparison: add_p().
# =============================================================================

rm(list = ls())

library(here)
library(readr)
library(dplyr)
library(forcats)
library(gtsummary)
library(gt)

df <- read_csv(here("data", "processed", "kazakhstan_cohort_clean.csv"),
               show_col_types = FALSE) %>%
  mutate(
    Sex        = factor(Sex),
    RAS_result = factor(RAS_result, levels = c("Negative", "Positive")),
    Culture    = factor(Culture,    levels = c("Negative", "Positive")),
    # Order to match the manuscript. Both "No pathology" and the "No patology"
    # spelling present in some dataset versions are listed; fct_relevel ignores
    # levels that are absent.
    Endoscopy  = fct_relevel(
      factor(Endoscopy),
      "No pathology", "No patology", "Non-atrophic",
      "C-1", "C-2", "C-3", "O-1", "O-2", "O-3",
      after = 0
    )
  )

df_table2 <- df %>% filter(!is.na(Endoscopy) & !is.na(Culture))

message("Table 2 cohort size: ", nrow(df_table2))
print(table(df_table2$Culture, useNA = "ifany"))

table2 <- df_table2 %>%
  select(Age, Sex, RAS_result, Endoscopy, Culture) %>%
  tbl_summary(
    by = Culture,
    missing = "no",
    statistic = list(
      all_continuous()  ~ "{mean} ± {sd}",
      all_categorical() ~ "{n} ({p}%)"
    ),
    digits = all_continuous() ~ 1
  ) %>%
  add_n() %>%
  add_p() %>%
  bold_labels() %>%
  modify_caption(
    "**Table 2. Baseline characteristics of patients by *H. pylori* culture result**"
  ) %>%
  modify_footnote(
    all_stat_cols(FALSE) ~ "Mean ± SD for continuous variables; n (%) for categorical variables"
  )

out_dir <- here("results", "tables")
dir.create(out_dir, recursive = TRUE, showWarnings = FALSE)
gtsave(as_gt(table2), file.path(out_dir, "Table2_Hpylori_Epidemiology.html"))
message("Wrote ", file.path(out_dir, "Table2_Hpylori_Epidemiology.html"))
