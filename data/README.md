# `data/` — not tracked in git

**No data files are committed to this repository.** Patient-level cohort data,
literature-extracted meta-analysis tables, and microbiome artifacts are kept
outside version control. `.gitignore` blocks `*.xlsx`, `*.csv` (except the
templates below), `*.rds`, `*.RData`, and related types under `data/raw/` and
`data/processed/`.

Place the files listed below into `data/raw/` before running `analysis/R/`.
Column definitions for every file are in
[`../docs/data-dictionary.md`](../docs/data-dictionary.md).

## Expected inputs

| Path                                             | Produced by            | Used by |
|--------------------------------------------------|------------------------|---------|
| `data/raw/kazakhstan_cohort.xlsx`                | Study team (Almaty/Oita) | `00_clean_data.R` |
| `data/processed/kazakhstan_cohort_clean.csv`     | `00_clean_data.R`      | `01`–`04` |
| `data/raw/CentralAsia_Hpylori_Prevalence.csv`    | Manual extraction from published studies | `05_figures_forest_plots.R`, meta-analysis Rmd |
| `data/raw/CentralAsia_Hpylori_Resistance.csv`    | Manual extraction from published studies | `05_figures_forest_plots.R`, meta-analysis Rmd |
| `data/raw/alpha-diversity.tsv`                   | `qiime diversity alpha` export | `analysis/microbiome/alpha_diversity.R` |
| `data/raw/microbiome_metadata.tsv`              | Study team             | `analysis/microbiome/alpha_diversity.R` |

The cohort spreadsheet has one header row to skip (`skip = 1`) and its first
worksheet is the analytic sheet.

## Templates

`data/templates/` holds **header-only** CSVs (column names, zero records) so you
can see the exact expected schema without any data leaving the study team:

- `kazakhstan_cohort_template.csv`
- `CentralAsia_Hpylori_Prevalence_template.csv`
- `CentralAsia_Hpylori_Resistance_template.csv`
