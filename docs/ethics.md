# Ethics, consent, and data availability

This repository holds the analysis code for a study of human participants. It
contains **no patient-level data** — see [`../data/README.md`](../data/README.md)
for what is and is not tracked, and the "Data availability" section below for
how to request the underlying records.

## Associated publication

> Dauyey K, Zhunussova G, Kaibullayeva J, Bondar Y, Yerzhan A, Medetbekova A,
> Kaisina A, Khabizhanova A, Seitbekov K, Yamaoka Y.
> **A single-center culture-based study of *Helicobacter pylori* in Kazakhstan
> with regional meta-analysis of prevalence and antibiotic resistance.**
> *Frontiers in Microbiology* 17 (2026).
> doi: [10.3389/fmicb.2026.1747006](https://doi.org/10.3389/fmicb.2026.1747006)

Published 22 January 2026 under [CC BY 4.0](https://creativecommons.org/licenses/by/4.0/).

The code in this repository produces the tables and figures reported in that
article. Where the two differ, the article is authoritative.

## Ethical approval

| Body | Reference |
|------|-----------|
| Ethics Committee, Institute of Genetics and Physiology, Almaty, Kazakhstan | № 1, 8 January 2024 |
| Ethics Committee, Oita University Faculty of Medicine, Japan | P-12-10 and #1660 |

The studies involving human participants were reviewed and approved by the
committees above. **Written informed consent was obtained from all
participants** prior to enrolment, endoscopy, and biopsy.

## Study setting

Single-centre, cross-sectional, culture-based study of 150 dyspeptic adults
undergoing upper endoscopy at the Scientific-Research Institute of Cardiology
and Internal Diseases (Almaty, Kazakhstan). Isolates were cold-chain
transported to Oita University (Japan) for culture and antimicrobial
susceptibility testing.

## Data availability

Per the published Data Availability Statement:

> The raw data supporting the conclusions of this article will be made
> available by the authors, without undue reservation.

Requests go to the corresponding author. Release of participant-level records
is subject to the approvals above and to a data transfer agreement; expect to
receive a de-identified extract rather than the source spreadsheet.

Two categories of data **are** in this repository and need no request:

- `data/meta/` — study-level counts transcribed from published literature.
- `results/meta-analysis/` — the meta-analysis tables and forest plots, fully
  reproducible from `data/meta/`.

## Handling rules for contributors

These are not stylistic preferences. Breaking them is a reportable data
incident under the approvals above.

1. **Never commit participant-level records.** `data/raw/` and
   `data/processed/` are git-ignored, and `.gitignore` blocks `*.csv`/`*.tsv`
   repository-wide by default. Do not use `git add -f` to defeat this.
2. **Direct identifiers stay out of every output.** `ID` (internal specimen
   identifier) must not appear in any committed table, figure, log, commit
   message, or issue.
3. **Treat `Nationality` as a quasi-identifier.** Self-reported ethnicity,
   combined with exact age and a single named centre in Almaty, is a
   re-identification path. It is collected for the cohort description; it
   should not be published as a cross-tabulated stratum.
4. **Suppress small cells before publication.** Cohort tables stratify a
   150-participant sample across up to 8 Kimura–Takemoto endoscopy categories.
   Collapse or suppress any cell with n < 5 in material intended for
   publication or preprint.
5. **Regenerate, do not commit, cohort outputs.** Everything under
   `results/tables/` and `results/figures/` derives from non-committed patient
   data and is git-ignored by design.
6. **If participant data is committed by mistake**, do not simply delete it in
   a follow-up commit — the blob remains in history and on any fork. Stop,
   notify the PI, and rewrite history (`git filter-repo`) before the branch is
   pushed or, if already pushed, in coordination with GitHub support.
