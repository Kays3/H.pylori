# `results/meta-analysis/` — committed outputs

These files are **regenerated**, not hand-edited. They are tracked (unlike the
rest of `results/`) because they derive entirely from `data/meta/`, which is in
the repo — so anyone can reproduce them exactly:

```bash
Rscript analysis/R/05_figures_forest_plots.R
```

R 4.4, `meta` 8.2, `metafor` 4.8. Freeman–Tukey double-arcsine transform
(`PFT`), random-effects (REML for the summary tables, inverse-variance for the
`meta::forest` figures). Pooled proportions and per-study values are
back-transformed with `metafor::transf.ipft.hm` / `transf.ipft`.

| File | Contents |
|------|----------|
| `Figure1_ForestPlot_Hpylori_Prevalence.pdf` | Forest plot, 13 Central Asian prevalence studies |
| `Figure2_ForestPlot_Clarithromycin_Resistance.pdf` | Forest plot, 4 clarithromycin-resistance studies |
| `Table_Prevalence_Summary.csv` | Pooled prevalence overall **and** by diagnostic method: `k`, pooled proportion, 95% CI, 95% prediction interval, I², τ², Cochran Q, df, p(Q) |
| `Table_Prevalence_PerStudy.csv` | Per-study proportion + 95% CI + random-effects weight |
| `Table_Resistance_Summary.csv` | Same summary columns for clarithromycin, metronidazole, amoxicillin (rows with `k < 2` left blank) |
| `Table_Clarithromycin_PerStudy.csv` | Per-study clarithromycin resistance + 95% CI + weight |

## Headline numbers (regenerate to confirm)

| Outcome | k | Pooled % (95% CI) | I² |
|---|---|---|---|
| *H. pylori* prevalence | 13 | 70.1 (59.5–79.7) | 96.5% |
| — by PCR | 5 | 73.9 (66.3–80.8) | 65.7% |
| — by ELISA | 3 | 67.9 (47.6–85.2) | 94.9% |
| — by UBT | 3 | 57.2 (26.2–85.3) | 98.9% |
| Clarithromycin resistance | 4 | 29.3 (10.3–52.8) | 90.8% |
| Metronidazole resistance | 3 | 56.4 (21.1–88.4) | 95.4% |
| Amoxicillin resistance | 2 | 9.0 (0–31.0) | 80.7% |

Heterogeneity is very high — pooled estimates are regional indicators, not
point prevalence (see `docs/revision-notes/methods-transparency.md`).
Resistance pools rest on ≤ 4 studies of mixed methodology; treat as
descriptive. Reconcile the `data/meta/README.md` data-quality flags before any
of these numbers go into the manuscript.
