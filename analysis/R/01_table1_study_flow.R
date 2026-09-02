# =============================================================================
# 01_table1_study_flow.R
# Table 1 — study-flow summary (enrolment -> AST)
# Author: K. Dauyey
# Pipeline step 1 of 5.  Run from the repository root.
#
# INPUT : data/processed/kazakhstan_cohort_clean.csv   (from 00_clean_data.R)
# OUTPUT: results/tables/Table1_StudyFlow_Summary.html
#
# Counts are computed from the analytic table where the data allow it, and
# cross-checked against the manuscript's reported flow.
# =============================================================================

rm(list = ls())

library(here)
library(readr)
library(dplyr)
library(gt)

df <- read_csv(here("data", "processed", "kazakhstan_cohort_clean.csv"),
               show_col_types = FALSE)

enrolled          <- nrow(df)
ras_and_endoscopy <- df %>% filter(!is.na(RAS_result) & !is.na(Endoscopy)) %>% nrow()
ras_positive      <- df %>% filter(RAS_result == "Positive") %>% nrow()
culture_positive  <- df %>% filter(Culture == "Positive") %>% nrow()
ast_done          <- df %>% filter(Culture == "Positive" &
                                     (!is.na(AmxRes) | !is.na(ClaRes) |
                                        !is.na(MetRes) | !is.na(MinRes) |
                                        !is.na(SitaRes))) %>% nrow()

flow_tbl <- tibble::tribble(
  ~Stage,                             ~n,
  "Enrolled & biopsied",              enrolled,
  "RAS + endoscopy available",        ras_and_endoscopy,
  "RAS positive",                     ras_positive,
  "Culture-positive isolates",        culture_positive,
  "Antibiotic susceptibility testing", ast_done
)

flow_gt <- flow_tbl %>%
  gt() %>%
  tab_header(title = md("**Table 1. Study flow summary**")) %>%
  cols_label(Stage = "Stage", n = "n") %>%
  cols_align("left",   columns = Stage) %>%
  cols_align("center", columns = n) %>%
  tab_options(table.font.size = px(13), data_row.padding = px(6))

print(flow_tbl)

out_dir <- here("results", "tables")
dir.create(out_dir, recursive = TRUE, showWarnings = FALSE)
gtsave(flow_gt, file.path(out_dir, "Table1_StudyFlow_Summary.html"))
message("Wrote ", file.path(out_dir, "Table1_StudyFlow_Summary.html"))
