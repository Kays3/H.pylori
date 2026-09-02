# Methods-transparency notes (peer-review revision)

Consolidated from the Nov 2025 – Jan 2026 revision cycle. These are the
methodological points to keep aligned between the manuscript, this code, and
`docs/study-overview.md`. No reviewer or patient details here.

## 1. Title / objectives
State the single-centre, culture-based, hospital-based design up front, and add
an explicit objective sentence: characterise culture-confirmed *H. pylori*
prevalence and resistance among dyspeptic patients in Almaty, and contextualise
within Central Asia via regional meta-analysis.

## 2. Sample transport & culture conditions (must be described)
- Biopsies for culture placed in transport medium, held at 4 °C.
- Cold-chain shipment Almaty → Oita University with −30 °C packs, ~48–72 h transit.
- Processed for culture on arrival.
- Loss of viability over long transport is a recognised limitation and the main
  reason for RAS/culture discordance — frame it that way, not as RAS error.

## 3. Culture & identification
- Selective Columbia agar + 7% horse blood + vancomycin/polymyxin B/trimethoprim.
- 37 °C, microaerophilic (~5% O₂, 10% CO₂, 85% N₂), 5–7 days.
- ID by morphology + urease/oxidase/catalase + Gram-negative curved bacilli.
- QC strain: *H. pylori* ATCC 43504. AST in duplicate, read by two investigators.

## 4. AST attrition
Report the exact "AST completed / culture-positive" fraction and state the
reason for the gap (insufficient growth on subculture, loss of viability in
storage). Mirror this in Limitations. `01_table1_study_flow.R` computes the
numbers.

## 5. Meta-analysis heterogeneity
- Expect I² > 85% from mixed diagnostic methods, populations, geography.
- Interpret pooled estimates as regional indicators, not point prevalence.
- Sensitivity analysis: drop serology-based studies (implemented in the Rmd).

## 6. Regression
n is too small for a stable multivariable model — acknowledge in Limitations;
defer independent-predictor analysis to larger population-based studies.

## 7. Multiple comparisons
Resistance profiling is exploratory; no formal correction applied; results
described, not used for hypothesis tests.

## 8. Clinical language
In vitro resistance ≠ eradication failure. Use "suggests reduced likelihood of
success of standard triple therapy". State clearly that clinical eradication
rates were not measured.

## 9. MDR interpretation
Report MDR % but note the small number of triple-resistant strains limits
outcome conclusions; highlight clarithromycin–metronidazole dual resistance as
the clinically relevant pattern.

## 10. Public-health framing
Offer an interim, local, non-prescriptive algorithm: avoid clarithromycin-based
triple therapy where local resistance is high; prefer bismuth quadruple;
reserve sitafloxacin / minocycline for rescue; build centralised culture +
molecular resistance surveillance.
