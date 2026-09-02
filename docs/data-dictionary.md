# Data dictionary

Definitions only — no data. Header-only templates are in `data/templates/`.

## 1. `kazakhstan_cohort.xlsx` (raw) → `kazakhstan_cohort_clean.csv` (processed)

Worksheet 1, one header row to skip. Leading columns are positional in the raw
sheet; `00_clean_data.R` renames them.

| Clean name | Raw position / label | Type | Values / notes |
|------------|----------------------|------|----------------|
| `Number` | `...1` | int | Row/serial number |
| `ID` | `...2` | chr | Internal specimen ID (**identifier — never commit**) |
| `Age` | `...3` | num | Years |
| `Sex` | `...4` | factor | `Male` / `Female` |
| `Nationality` | `...5` | factor | Self-reported ethnicity (**do not commit**) |
| `Country` | `...6` | chr | Country of residence |
| `RAS_result` | `...7` | factor | `Negative` / `Positive` — Rapid Antigen Stool test |
| `Culture` | `...8` | factor | `Negative` / `Positive` — biopsy culture |
| `Endoscopy` | `...9` | factor | Kimura–Takemoto: `No pathology`, `Non-atrophic`, `C-1`..`C-3`, `O-1`..`O-3` |
| `pylori_stock` | `...10` | factor | Isolate stored? `Yes` |
| `Amx_MIC` | `Amx, ug/ml` | num | Amoxicillin MIC (µg/mL) |
| `Cla_MIC` | `Cla, ug/ml` | num | Clarithromycin MIC (µg/mL) |
| `Min_MIC` | `Min, ug/ml` | num | Minocycline MIC (µg/mL) |
| `Sita_MIC` | `Sita, ug/ml` | num | Sitafloxacin MIC (µg/mL) |
| `Met_MIC` | `Met, ug/ml` | num | Metronidazole MIC (µg/mL) |
| `Amx.Phen` | `Amx.Phen` | 0/1 | Amoxicillin phenotype: 1 = resistant |
| `Cla.Phen` | `Cla.Phen` | 0/1 | Clarithromycin phenotype |
| `Min.Phen` | `Min.Phen` | 0/1 | Minocycline phenotype |
| `Sita.Phen` | `Sita.Phen` | 0/1 | Sitafloxacin phenotype |
| `Met.Phen` | `Met.Phen` | 0/1 | Metronidazole phenotype |
| `DNA_conc` | `...21` | num | Extracted DNA concentration (ng/µL) |
| `Sequencing_done` | `...22` | chr | Whether WGS was performed |

Derived by `00_clean_data.R`: `AmxRes`, `ClaRes`, `MinRes`, `SitaRes`,
`MetRes` — factor `Susceptible` / `Resistant` from the `*.Phen` 0/1 columns.

**Identifiers / quasi-identifiers** (`ID`, `Nationality`, exact `Age` with
small strata) must stay out of version control.

## 2. `data/meta/CentralAsia_Hpylori_Prevalence.csv`  *(tracked in-repo)*

Study-level figures transcribed from published prevalence studies (Central Asia
+ neighbours). Row-by-row provenance and known `Positive` vs `Prevalence_%`
discrepancies: [`../data/meta/README.md`](../data/meta/README.md).

| Column | Type | Notes |
|--------|------|-------|
| `Country` | chr | Study country |
| `Author_Year` | chr | First author + year, e.g. `Mežmale 2021` |
| `N` | int | Participants tested |
| `Positive` | int | *H. pylori*–positive |
| `Diagnostic_Method` | chr | `Serology/IgG`, `UBT`, `PCR`, `Culture`, `Histology`, … |
| `Prevalence_%` | num | `Positive / N * 100` (redundant, for checking) |

## 3. `data/meta/CentralAsia_Hpylori_Resistance.csv`  *(tracked in-repo)*

Study-level figures transcribed from published resistance studies.

| Column | Type | Notes |
|--------|------|-------|
| `Country` | chr | Study country |
| `Author_Year` | chr | First author + year |
| `N_Isolates` | int | Isolates tested |
| `Clarithromycin_Res_%` | num | % resistant |
| `Metronidazole_Res_%` | num | % resistant (may be `NA`) |
| `Amoxicillin_Res_%` | num | % resistant (may be `NA`) |
| `Mutation_Info` | chr | Free text, e.g. `23S rRNA A2143G` |

`metaprop()` reconstructs events as `round(pct * N_Isolates / 100)`.

## 4. Microbiome — `alpha-diversity.tsv`, `microbiome_metadata.tsv`

| File | Column | Notes |
|------|--------|-------|
| `alpha-diversity.tsv` | `SampleID` (col 1, unnamed in QIIME export) | sample id |
| | `shannon_entropy` | Shannon index from `qiime diversity alpha` |
| `microbiome_metadata.tsv` | `SampleID` | join key |
| | `Grp` | study group label (e.g. `1` / `2`) |
