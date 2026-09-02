# =============================================================================
# 03_table3_resistance.R
# Table 3 — antibiotic resistance in culture-positive isolates
#           (single / pairwise / triple combinations, feeding an MDR summary)
# Author: K. Dauyey
# Pipeline step 3 of 5.  Run from the repository root.
#
# INPUT : data/processed/kazakhstan_cohort_clean.csv   (from 00_clean_data.R)
# OUTPUT: results/tables/Table3_Resistance_Overall.html
#         results/tables/Table3_Resistance_Pairwise.html
#         results/tables/Table3_Resistance_Triple.html
#
# The three tables are merged into the manuscript's Table 3 in the word
# processor. Denominator N = culture-positive isolates.
# =============================================================================

rm(list = ls())

library(here)
library(readr)
library(dplyr)
library(tidyr)
library(purrr)
library(gt)

df <- read_csv(here("data", "processed", "kazakhstan_cohort_clean.csv"),
               show_col_types = FALSE)

df_res <- df %>%
  filter(Culture == "Positive") %>%
  mutate(
    Amoxicillin    = as.integer(AmxRes  == "Resistant"),
    Clarithromycin = as.integer(ClaRes  == "Resistant"),
    Metronidazole  = as.integer(MetRes  == "Resistant"),
    Minocycline    = as.integer(MinRes  == "Resistant"),
    Sitafloxacin   = as.integer(SitaRes == "Resistant")
  )

abx <- c("Amoxicillin", "Clarithromycin", "Metronidazole",
         "Minocycline", "Sitafloxacin")
N <- nrow(df_res)
message("Culture-positive isolates (denominator N): ", N)

out_dir <- here("results", "tables")
dir.create(out_dir, recursive = TRUE, showWarnings = FALSE)

# --- 1. Single-agent resistance ------------------------------------------------
overall_res <- df_res %>%
  summarise(across(all_of(abx), ~ sum(.x == 1, na.rm = TRUE))) %>%
  pivot_longer(everything(), names_to = "Antibiotic", values_to = "Resistant_N") %>%
  mutate(Percent = round(Resistant_N / N * 100, 1))

overall_res %>%
  gt() %>%
  tab_header(title = "Single-agent resistance in culture-positive H. pylori") %>%
  cols_label(Resistant_N = "No. resistant", Percent = "% resistant") %>%
  tab_options(table.font.size = "small") %>%
  gtsave(file.path(out_dir, "Table3_Resistance_Overall.html"))

# --- 2. Pairwise combinations ------------------------------------------------
pairwise_res <- map_dfr(combn(abx, 2, simplify = FALSE), function(pair) {
  n <- sum(df_res[[pair[1]]] == 1 & df_res[[pair[2]]] == 1, na.rm = TRUE)
  tibble(Combination = paste(pair, collapse = " + "),
         Count = n, Percent = round(n / N * 100, 1))
})

pairwise_res %>%
  gt() %>%
  tab_header(title = "Pairwise antibiotic-resistance combinations") %>%
  cols_label(Combination = "Antibiotic combination",
             Count = "No. isolates", Percent = "% of isolates") %>%
  tab_options(table.font.size = "small") %>%
  gtsave(file.path(out_dir, "Table3_Resistance_Pairwise.html"))

# --- 3. Triple combinations (non-zero only) ---------------------------------
triple_res <- map_dfr(combn(abx, 3, simplify = FALSE), function(trio) {
  n <- sum(df_res[[trio[1]]] == 1 & df_res[[trio[2]]] == 1 &
             df_res[[trio[3]]] == 1, na.rm = TRUE)
  tibble(Combination = paste(trio, collapse = " + "),
         Count = n, Percent = round(n / N * 100, 1))
})

triple_res %>%
  filter(Count > 0) %>%
  gt() %>%
  tab_header(title = "Triple antibiotic-resistance combinations") %>%
  cols_label(Combination = "Antibiotic combination",
             Count = "No. isolates", Percent = "% of isolates") %>%
  tab_options(table.font.size = "small") %>%
  gtsave(file.path(out_dir, "Table3_Resistance_Triple.html"))

# --- MDR summary (>= 3 agent classes) --------------------------------------
mdr <- df_res %>%
  mutate(n_resistant = rowSums(across(all_of(abx)), na.rm = TRUE)) %>%
  summarise(
    MDR_N    = sum(n_resistant >= 3, na.rm = TRUE),
    MDR_pct  = round(mean(n_resistant >= 3, na.rm = TRUE) * 100, 1)
  )
message("MDR (>=3 agents): ", mdr$MDR_N, " isolates (", mdr$MDR_pct, "%)")

message("Wrote 3 tables to ", out_dir)
