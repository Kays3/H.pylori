# *Helicobacter pylori* in Kazakhstan — analysis code & literature

Reproducible analysis code and a curated literature base for the study:

> **A single-centre culture-based study of *Helicobacter pylori* in Kazakhstan
> with a regional meta-analysis of prevalence and antibiotic resistance.**

The project characterises culture-confirmed *H. pylori* prevalence and
antibiotic-resistance patterns among dyspeptic patients in Almaty, Kazakhstan,
and places the findings in a Central Asian context via a small aggregate
meta-analysis. A companion 16S microbiome sub-analysis (alpha diversity) is
also included.

---

## ⚠️ What is *not* in this repository

This repo holds **code and references only**. It contains **no data and no
sensitive material**:

- no patient-level or cohort data (age, sex, nationality, IDs, MIC values, …),
- no extracted meta-analysis spreadsheets,
- no sequencing data or QIIME artifacts,
- no manuscripts, reviewer correspondence, or copyrighted PDFs.

Datasets live outside version control (see [`data/README.md`](data/README.md)).
`.gitignore` is configured to block the common data/manuscript file types.

---

## Repository layout

```
pylory_kz/
├── README.md                     ← you are here
├── analysis/
│   ├── R/                         Numbered R scripts, run in order
│   │   ├── 00_clean_data.R        Read raw cohort sheet → tidy analytic table
│   │   ├── 01_table1_study_flow.R Study-flow / CONSORT-style counts
│   │   ├── 02_table2_epidemiology.R  Baseline characteristics by culture result
│   │   ├── 03_table3_resistance.R    Single / dual / triple resistance & MDR
│   │   ├── 04_supp_ras_vs_culture.R  RAS vs culture performance + ROC
│   │   └── 05_figures_forest_plots.R Forest plots (Fig 1 prevalence, Fig 2 CLR)
│   ├── rmd/
│   │   └── centralasia_meta_analysis.Rmd   Full regional meta-analysis report
│   └── microbiome/
│       └── alpha_diversity.R      QIIME 2 commands + R plotting of Shannon index
├── data/
│   ├── README.md                 How to obtain / place the datasets
│   └── templates/                Header-only CSV templates (no records)
├── results/
│   ├── figures/                  Generated figures (git-ignored)
│   └── tables/                   Generated tables (git-ignored)
├── literature/
│   ├── references.bib            BibTeX for cited + background works
│   └── reading-list.md           Annotated, categorised reading list w/ DOIs
├── docs/
│   ├── study-overview.md         Study design, cohort flow, variable definitions
│   ├── data-dictionary.md        Column-by-column definitions for every dataset
│   ├── reproducibility.md        Environment + exact run order
│   └── revision-notes/           Methods-transparency notes from peer review
└── env/
    └── r-packages.md             R version + package list to recreate the env
```

## Quick start

```bash
# 1. Put the datasets in place (they are NOT in the repo)
#    see data/README.md for the expected filenames and columns

# 2. From an R session at the repo root:
Rscript analysis/R/00_clean_data.R
Rscript analysis/R/01_table1_study_flow.R
Rscript analysis/R/02_table2_epidemiology.R
Rscript analysis/R/03_table3_resistance.R
Rscript analysis/R/04_supp_ras_vs_culture.R
Rscript analysis/R/05_figures_forest_plots.R

# 3. Meta-analysis report
Rscript -e 'rmarkdown::render("analysis/rmd/centralasia_meta_analysis.Rmd")'
```

All scripts resolve paths relative to the repo root (via the `here` package),
read from `data/`, and write to `results/`. No `setwd()` calls, no absolute
paths. See [`docs/reproducibility.md`](docs/reproducibility.md) for details.

## Analysis provenance

The R scripts here are cleaned, de-pathed, and renumbered versions of the
working scripts used for the manuscript (Aug 2025 – Jan 2026 revision cycle).
Logic is unchanged; only hard-coded personal paths, scratch code, and
data-writing side effects were removed so the pipeline runs from a clean
checkout.

## Authorship

Analysis code: K. Dauyey. Study: Institute of Genetics and Physiology
(Almaty, Kazakhstan) in collaboration with Oita University (Japan).
