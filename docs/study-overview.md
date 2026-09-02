# Study overview

## Design

Single-centre, culture-based cross-sectional study of dyspeptic patients
undergoing upper endoscopy in Almaty, Kazakhstan, with a regional aggregate
meta-analysis for context. Biopsy specimens designated for culture were
cold-chain transported from Almaty to Oita University (Japan) for culture and
phenotypic antimicrobial susceptibility testing (AST).

## Cohort flow (analytic definitions)

| Stage | Definition |
|-------|------------|
| Enrolled & biopsied | All patients with an endoscopy/biopsy record |
| RAS + endoscopy available | Non-missing `RAS_result` **and** `Endoscopy` |
| RAS positive | `RAS_result == "Positive"` |
| Culture-positive isolates | `Culture == "Positive"` |
| AST performed | Culture-positive isolate with at least one phenotype result |

Reported counts have shifted across dataset versions as new batches were added
(e.g. 149 → 150 enrolled; 113 → 148 with RAS + endoscopy). Scripts compute the
counts from the analytic table so the numbers track the current dataset.

## Key measures

- **Prevalence** — proxied by `RAS_result` (Rapid Antigen Stool test) and by
  `Culture`. Culture underestimates infection after long transport
  (loss of viability, coccoid forms); this is discussed, not treated as RAS error.
- **Antibiotic resistance** — phenotypic AST for amoxicillin, clarithromycin,
  metronidazole, minocycline, sitafloxacin. Binary resistant/susceptible plus
  MIC (µg/mL). MDR = resistant to ≥ 3 agents.
- **Endoscopy** — Kimura–Takemoto atrophy classification
  (No pathology, Non-atrophic, C-1…C-3, O-1…O-3).

## Outputs

| Manuscript element | Script |
|--------------------|--------|
| Table 1 — study flow | `analysis/R/01_table1_study_flow.R` |
| Table 2 — epidemiology by culture | `analysis/R/02_table2_epidemiology.R` |
| Table 3 — resistance (single/dual/triple, MDR) | `analysis/R/03_table3_resistance.R` |
| Supplementary — RAS vs culture, ROC | `analysis/R/04_supp_ras_vs_culture.R` |
| Figure 1 — regional prevalence forest plot | `analysis/R/05_figures_forest_plots.R` → `results/meta-analysis/` |
| Figure 2 — clarithromycin resistance forest plot | `analysis/R/05_figures_forest_plots.R` → `results/meta-analysis/` |
| Meta-analysis summary + per-study tables | `analysis/R/05_figures_forest_plots.R` → `results/meta-analysis/*.csv` |
| Regional meta-analysis report | `analysis/rmd/centralasia_meta_analysis.Rmd` |
| Microbiome alpha diversity | `analysis/microbiome/alpha_diversity.R` |

## Collaborators / provenance

- Study & sampling: Institute of Genetics and Physiology, Almaty, Kazakhstan.
- Culture & AST: Oita University, Japan.
- Target journal: *Frontiers* (revision cycle Nov 2025 – Jan 2026).
