# Reproducibility

## Environment

- **R** ≥ 4.3
- Packages (CRAN): `here`, `readr`, `readxl`, `dplyr`, `tidyr`, `purrr`,
  `forcats`, `stringr`, `ggplot2`, `gt`, `gtsummary`, `meta`, `metafor`,
  `pROC`, `rmarkdown`
- Full list with install line: [`../env/r-packages.md`](../env/r-packages.md)
- **QIIME 2** (microbiome upstream only) ≥ 2024.2 — used outside this repo to
  produce `alpha-diversity.tsv`.

```r
install.packages(c(
  "here","readr","readxl","dplyr","tidyr","purrr","forcats","stringr",
  "ggplot2","gt","gtsummary","meta","metafor","pROC","rmarkdown"
))
```

## Path convention

Every script calls `library(here)` and resolves paths with `here::here(...)`
from the repository root. There are **no `setwd()` calls and no absolute
paths**. Run scripts with the working directory anywhere inside the repo, or:

```bash
Rscript analysis/R/00_clean_data.R
```

## Run order

| # | Script | Needs | Produces |
|---|--------|-------|----------|
| 0 | `analysis/R/00_clean_data.R` | `data/raw/kazakhstan_cohort.xlsx` | `data/processed/kazakhstan_cohort_clean.csv` |
| 1 | `analysis/R/01_table1_study_flow.R` | step 0 output | `results/tables/Table1_StudyFlow_Summary.html` |
| 2 | `analysis/R/02_table2_epidemiology.R` | step 0 output | `results/tables/Table2_Hpylori_Epidemiology.html` |
| 3 | `analysis/R/03_table3_resistance.R` | step 0 output | `results/tables/Table3_Resistance_*.html` |
| 4 | `analysis/R/04_supp_ras_vs_culture.R` | step 0 output | Supp table + ROC figure |
| 5 | `analysis/R/05_figures_forest_plots.R` | `data/meta/CentralAsia_Hpylori_*.csv` *(in repo)* | Figure 1 + Figure 2 PDFs |
| — | `analysis/rmd/centralasia_meta_analysis.Rmd` | `data/meta/CentralAsia_Hpylori_*.csv` *(in repo)* | HTML report |
| — | `analysis/microbiome/alpha_diversity.R` | `data/raw/alpha-diversity.tsv`, `microbiome_metadata.tsv` | Shannon figure |

One-shot:

```bash
for f in analysis/R/0*.R; do echo ">>> $f"; Rscript "$f" || break; done
Rscript -e 'rmarkdown::render("analysis/rmd/centralasia_meta_analysis.Rmd")'
```

## Determinism

- No RNG is used in the table/figure scripts.
- `metaprop()` uses the Freeman–Tukey transform (`sm = "PFT"`), random effects,
  inverse-variance weighting — deterministic given the input CSV.
- `results/` is git-ignored; regenerate rather than commit outputs.

## Tables → manuscript

`gt` / `gtsummary` write `.html`. The manuscript workflow opens those in a word
processor and merges the single/dual/triple resistance tables into one Table 3.
