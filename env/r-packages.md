# R environment

Tested with **R 4.3+**. CRAN packages only.

```r
install.packages(c(
  # infrastructure
  "here", "rmarkdown",
  # data wrangling
  "readr", "readxl", "dplyr", "tidyr", "purrr", "forcats", "stringr",
  # tables
  "gt", "gtsummary",
  # figures
  "ggplot2",
  # meta-analysis
  "meta", "metafor",
  # diagnostics
  "pROC"
))
```

## Where each package is used

| Package | Scripts |
|---------|---------|
| `here` | all |
| `readxl` | `00_clean_data.R` |
| `readr` | `01`–`05`, Rmd, microbiome |
| `dplyr` / `tidyr` / `purrr` | `00`–`04`, microbiome |
| `forcats` | `02_table2_epidemiology.R` |
| `gt` | `01`, `03`, `04` |
| `gtsummary` | `02_table2_epidemiology.R` |
| `ggplot2` | `04_supp_ras_vs_culture.R`, `alpha_diversity.R` |
| `meta` | `05_figures_forest_plots.R`, Rmd |
| `metafor` | `centralasia_meta_analysis.Rmd` |
| `pROC` | `04_supp_ras_vs_culture.R` |
| `rmarkdown` | render the Rmd |

## Optional: pin with renv

```r
install.packages("renv")
renv::init()      # snapshot after installing the packages above
```

Session info is printed at the end of the meta-analysis Rmd; paste it into the
manuscript's reproducibility statement.
