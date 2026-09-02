# `data/meta/` — regional meta-analysis inputs (versioned)

Unlike `data/raw/` (patient-level, **never committed**), these files are
**aggregate figures transcribed from published studies** — study, year, sample
size, positives, diagnostic method. They contain no patient data and are kept
under version control so the meta-analysis is reproducible from a clean
checkout.

Consumed by:
- `analysis/R/05_figures_forest_plots.R` → Figure 1 (prevalence), Figure 2 (clarithromycin)
- `analysis/rmd/centralasia_meta_analysis.Rmd`

Schema: see [`../../docs/data-dictionary.md`](../../docs/data-dictionary.md) §2–§3.

---

## `CentralAsia_Hpylori_Prevalence.csv` (13 rows)

`event = Positive`, `n = N`; `Prevalence_%` is an unused cross-check column.

| Author_Year | Country | N | Positive | Method | references.bib key |
|---|---|---|---|---|---|
| Current study (2025) | Kazakhstan | 150 | 86 | Culture | — (this study) |
| Seisenbekova et al. (2025) | Kazakhstan | 369 | 109 | UBT | `seisenbekova2025karaganda` |
| Mezmale et al. (2021) | Kazakhstan | 166 | 104 | PCR | `mezmale2021kazakhstan` |
| Abylkasymova (2012) | Kazakhstan | 52 | 43 | PCR | *to verify* |
| Aldiyarova M (2011) | Kazakhstan | 446 | 257 | UBT | *to verify* |
| Kulmagambetova (2011) | Kazakhstan | 19 | 16 | PCR | *to verify* |
| Zhangabylov et al. (2002) | Kazakhstan | 288 | 230 | ELISA | *to verify* |
| Nurgalieva et al. (2001) | Kazakhstan | 103 | 76 | ELISA | *to verify* |
| Abdiev et al. (2010) | Uzbekistan | 167 | 125 | PCR | *to verify* |
| Abdiev et al. (2008) | Uzbekistan | 95 | 69 | PCR | *to verify* |
| Dzhumabaev et al. (2015) | Kyrgyzstan | 116 | 55 | ELISA | *to verify* |
| Dzhumabaev M (2008) | Kyrgyzstan | 359 | 340 | Histology | *to verify* |
| Akbarova et al. (2017) | Kyrgyzstan | 116 | 96 | UBT | *to verify* |

### Known data-quality items (reconcile against sources before final submission)

`Positive / N` does not equal the recorded `Prevalence_%` for three rows — the
percentage column was not recomputed after `Positive` was last edited. The
analysis uses `Positive` and `N` only, so figures are unaffected, but resolve
these before the numbers appear in text:

| Row | Positive/N | Prevalence_% column | Note |
|---|---|---|---|
| Abylkasymova (2012) | 43/52 = 82.7% | 91.7 | earlier draft had `Positive = 48` (→ 92.3%) |
| Nurgalieva et al. (2001) | 76/103 = 73.8% | 85.4 | earlier draft had `Positive = 88` (→ 85.4%) |
| Dzhumabaev et al. (2015) | 55/116 = 47.4% | 47.4 | consistent (listed for completeness) |

### Curation history (local working copies, not committed)

Two sibling files existed in the authors' working folder on 2026-01-06:

- `*_mod.csv` — 12 rows: fixes the `Mežmale` spelling, **drops** the
  `Dzhumabaev M (2008)` histology row, uses `Dzhumabaev 2015 = 57/116`.
- `*_old.csv` — pre-revision: `Current study = 149/86`, plus
  `Dzhumabaev et al. (2014)` histology `286/359` instead of the 2008 row.

The file shipped here matches the input actually read by the final figure
script (`figure1_2_mod.R`, "reviewer 3, January 6 2026"), with the single
cosmetic fix `Me_male → Mezmale`.

---

## `CentralAsia_Hpylori_Resistance.csv` (4 rows)

Events reconstructed by `metaprop()` as `round(pct * N_Isolates / 100)`.

| Author_Year | Country | N_Isolates | CLR % | MTZ % | AMX % | Mutation | references.bib key |
|---|---|---|---|---|---|---|---|
| Kulmambetova et al. (2015) | Kazakhstan | 20 | 65 | 31.3 | 18.8 | 23S rRNA A2143G | `kulmambetova2015kazakh` |
| Lazebnik et al. (2012) | Russia | 74 | 14.5 | 45 | — | — | *to verify* |
| Karimov et al. (2019) | Uzbekistan | 30 | 13.3 | — | — | A2142G/C | `karimov2019uzbekistan` |
| Current study (2025) | Kazakhstan | 86 | 33.7 | 87.2 | 3 | N/A | — (this study) |

`Current study` here uses the December-2025 dataset (86 isolates). An earlier
October working copy had 66 isolates (CLR 30.3%, MTZ 87.9%).

---

## Updating

1. Edit the CSV (keep the header, one study per row, blank = missing).
2. Add/complete the matching entry in `../../literature/references.bib` and
   replace the *to verify* marker above with its key.
3. Re-run `analysis/R/05_figures_forest_plots.R` and re-knit the Rmd.
