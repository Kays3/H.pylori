# `data/`

Two zones with different rules:

| Subdir | Tracked? | Contents |
|--------|----------|----------|
| `data/meta/` | **yes** | Regional meta-analysis inputs — study-level counts transcribed from published papers. No individuals. See [`meta/README.md`](meta/README.md). |
| `data/templates/` | **yes** | Header-only CSVs (column names, zero records). |
| `data/raw/`, `data/processed/` | **no** — git-ignored | Patient-level cohort data, microbiome artifacts. Never committed. |

`.gitignore` blocks `*.xlsx`, `*.rds`, `*.RData`, and CSV/TSV content under
`data/raw/` and `data/processed/`, while explicitly allowing `data/meta/` and
`data/templates/`.

Column definitions for every file are in
[`../docs/data-dictionary.md`](../docs/data-dictionary.md).

## Inputs you must supply (not in the repo)

Place these into `data/raw/` before running the cohort scripts (`00`–`04`) and
the microbiome script:

| Path                                             | Produced by            | Used by |
|--------------------------------------------------|------------------------|---------|
| `data/raw/kazakhstan_cohort.xlsx`                | Study team (Almaty/Oita) | `00_clean_data.R` |
| `data/processed/kazakhstan_cohort_clean.csv`     | `00_clean_data.R`      | `01`–`04` |
| `data/raw/alpha-diversity.tsv`                   | `qiime diversity alpha` export | `analysis/microbiome/alpha_diversity.R` |
| `data/raw/microbiome_metadata.tsv`              | Study team             | `analysis/microbiome/alpha_diversity.R` |

The cohort spreadsheet has one header row to skip (`skip = 1`) and its first
worksheet is the analytic sheet.

## Inputs already in the repo

| Path | Used by |
|------|---------|
| `data/meta/CentralAsia_Hpylori_Prevalence.csv` | `05_figures_forest_plots.R`, `centralasia_meta_analysis.Rmd` |
| `data/meta/CentralAsia_Hpylori_Resistance.csv` | `05_figures_forest_plots.R`, `centralasia_meta_analysis.Rmd` |

## Templates

`data/templates/` holds **header-only** CSVs (column names, zero records) so you
can see the exact expected schema without any data leaving the study team:

- `kazakhstan_cohort_template.csv`
- `CentralAsia_Hpylori_Prevalence_template.csv`
- `CentralAsia_Hpylori_Resistance_template.csv`
