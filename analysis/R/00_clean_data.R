# =============================================================================
# 00_clean_data.R
# H. pylori Kazakhstan study — read raw cohort sheet, produce tidy analytic table
# Author: K. Dauyey
# Pipeline step 0 of 5.  Run from the repository root.
#
# INPUT : data/raw/kazakhstan_cohort.xlsx      (worksheet 1, one header row to skip)
# OUTPUT: data/processed/kazakhstan_cohort_clean.csv
#
# The raw sheet uses positional columns; the first 10 fields and the
# DNA/sequencing fields are renamed by position, MIC fields by their label,
# and the phenotype fields (0/1) are recoded to Susceptible/Resistant.
# =============================================================================

rm(list = ls())

library(here)
library(readxl)
library(dplyr)

raw_path <- here("data", "raw", "kazakhstan_cohort.xlsx")
out_path <- here("data", "processed", "kazakhstan_cohort_clean.csv")

if (!file.exists(raw_path)) {
  stop("Missing input: ", raw_path,
       "\nSee data/README.md for the expected file and schema.")
}

df <- read_excel(raw_path, sheet = 1, skip = 1)

# --- Rename the leading positional columns --------------------------------------
df <- df %>%
  rename(
    Number          = `...1`,
    ID              = `...2`,
    Age             = `...3`,
    Sex             = `...4`,
    Nationality     = `...5`,
    Country         = `...6`,
    RAS_result      = `...7`,   # Rapid Antigen Stool test
    Culture         = `...8`,
    Endoscopy       = `...9`,   # Kimura-Takemoto category
    pylori_stock    = `...10`,
    DNA_conc        = `...21`,
    Sequencing_done = `...22`
  )

# --- Rename MIC columns by their in-sheet labels ------------------------------
df <- df %>%
  rename(
    Amx_MIC  = `Amx, ug/ml`,
    Cla_MIC  = `Cla, ug/ml`,
    Min_MIC  = `Min, ug/ml`,
    Sita_MIC = `Sita, ug/ml`,
    Met_MIC  = `Met, ug/ml`
  )

# --- Types -------------------------------------------------------------------
df <- df %>%
  mutate(
    Age        = as.numeric(Age),
    Sex        = factor(Sex),
    Nationality = factor(Nationality),
    RAS_result = factor(RAS_result, levels = c("Negative", "Positive")),
    Culture    = factor(Culture,    levels = c("Negative", "Positive")),
    Endoscopy  = factor(Endoscopy),
    across(c(Amx_MIC, Cla_MIC, Min_MIC, Sita_MIC, Met_MIC), as.numeric),
    across(ends_with(".Phen"), as.numeric)
  )

# --- Recode phenotype (0/1) -> Susceptible/Resistant ------------------------
convert_resistance <- function(x) {
  factor(ifelse(x == 1, "Resistant", "Susceptible"),
         levels = c("Susceptible", "Resistant"))
}

df <- df %>%
  mutate(
    AmxRes  = convert_resistance(`Amx.Phen`),
    ClaRes  = convert_resistance(`Cla.Phen`),
    MinRes  = convert_resistance(`Min.Phen`),
    SitaRes = convert_resistance(`Sita.Phen`),
    MetRes  = convert_resistance(`Met.Phen`)
  )

# --- Write -----------------------------------------------------------------
dir.create(dirname(out_path), recursive = TRUE, showWarnings = FALSE)
write.csv(df, out_path, row.names = FALSE)

message("Wrote ", out_path, "  (", nrow(df), " rows, ", ncol(df), " columns)")
