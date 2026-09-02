# Reading list

Annotated, categorised. BibTeX keys refer to
[`references.bib`](references.bib). Entries marked *(to complete)* are known
from working notes but need full bibliographic details verified against the
publisher before they are cited. No PDFs are stored in this repository.

---

## 1. Global burden & gastric-cancer link

| Work | Key | Why it matters here |
|------|-----|---------------------|
| Park et al. 2025, *Nat Med* | `park2025gastric` | Country-level preventable gastric-cancer estimates; frames the Kazakhstan burden. |
| Chen et al. 2024, *Gastroenterology* | `chen2024globalprev` | Global prevalence trend 1980–2022 and GC incidence; comparator for our prevalence numbers. |
| Duan et al. 2025, *J Hematol Oncol* | `duan2025mechanisms` | Mechanistic review, *H. pylori* → GC. |
| Wizenty & Sigal 2025, *Nat Rev Gastroenterol Hepatol* | `wizenty2025principles` | Microbiota + *H. pylori* carcinogenesis; supports the microbiome sub-analysis. |
| Ono et al. 2025, *Sci Rep* | `ono2025eradication` | Pooled Japanese cohorts: eradication → GC prevention. |
| Taszhanov et al. 2022, *APJCP* | `taszhanov2022gastric` | Geographic variation of GC incidence within Kazakhstan. |

## 2. Antibiotic resistance & treatment

| Work | Key | Note |
|------|-----|------|
| Schulz et al. 2025, *Gut* | `schulz2025resistance` | Current global resistance picture and mitigation; anchors the Discussion. |
| Yamaoka 2024, *J Gastroenterol Hepatol* | `yamaoka2024revolution` | Treatment "revolution" review (vonoprazan, tailored therapy). |
| Liang et al. 2020, *Ther Adv Gastroenterol* | `liang2020taiwan` | Multicentre resistance-trend template (2013–2019, Taiwan). |
| Bui et al. 2025, *BMC Microbiol* | `bui2025vietnam` | HTS-based genotype↔phenotype resistance in Vietnam; model for our sequencing follow-up. |
| Taipei/Asia-Pacific consensus 2025 *(to complete)* | — | "Gut Taipei consensus 2025" in working notes; regimen recommendations. |

## 3. Central Asia / Kazakhstan / neighbours

| Work | Key | Note |
|------|-----|------|
| Seisenbekova et al. 2025, *J Clin Med Kazakhstan* | `seisenbekova2025centralasia` | "Data from Central Asia" — direct regional comparator for resistance. |
| Seisenbekova et al. 2025, *Future Sci OA* | `seisenbekova2025karaganda` | Karaganda outpatient prevalence + risk factors. |
| Lavrinenko et al. 2025, *JGH Open* | `lavrinenko2025detection` | Review of *H. pylori* detection methods used in Kazakhstan (RAS/culture/PCR context). |
| Kulmambetova et al. 2015, *Biotechnol Theory Pract* | `kulmambetova2015kazakh` | Earlier Kazakh isolate resistance data. |
| Mežmale et al. 2021, *APJCP* | `mezmale2021kazakhstan` | Asymptomatic-adult prevalence in Kazakhstan. |
| Karimov et al. 2019, *Eff Pharmacother* | `karimov2019uzbekistan` | Uzbekistan prevalence + molecular characteristics. |
| Lhamo et al. 2025, *Gut Pathog* | `lhamo2025bhutan` | Bhutan resistance; wider Asian comparator. |
| Kyrgyzstan smoking/alcohol/*H. pylori* study *(to complete)* | — | Ethnic-group risk-factor study, in working notes. |
| Russia resistance 2025 *(to complete)* | — | Clarithromycin resistance + adjuncts; comparator. |
| Nepal / Bangladesh / Myanmar / Sri Lanka epidemiology *(to complete)* | — | South/Southeast Asia prevalence + ABR papers held for the meta-analysis pool. |

## 4. Diagnostics — RAS, culture, PCR

| Work | Key | Note |
|------|-----|------|
| Lavrinenko et al. 2025, *JGH Open* | `lavrinenko2025detection` | See §3. |
| Syam et al. 2015, *PLoS ONE* | `syam2015indonesia` | Prevalence/diagnostics across Indonesian islands. |
| Molecular diagnostic-kit evaluations (Tsuda et al. 2022 *Helicobacter*; Wakamatsu et al. 2026 *BioMed Res Int*) *(to complete)* | — | Stool-antigen / molecular kit performance; supports RAS-vs-culture discussion. |
| ELISA vs PCR comparison (Russian-language) *(to complete)* | — | Method-sensitivity comparison. |

## 5. Genomics, mobilome, ancient DNA

| Work | Key | Note |
|------|-----|------|
| Bui et al. 2025, *BMC Microbiol* | `bui2025vietnam` | See §2. |
| Yamaoka mobilome review *(to complete)* | — | *H. pylori* mobile genetic elements; relevant if WGS follow-up proceeds. |
| Ancient *H. pylori* (Matsumoto 2024; Yamaoka 2024) *(to complete)* | — | Phylogeography / population structure context for Central Asian strains. |
| Complete-genome reports (e.g. Mejia et al. 2025, Colombia) *(to complete)* | — | Reference-genome methodology template. |

## 6. Gastric microbiome

| Work | Key | Note |
|------|-----|------|
| Wizenty & Sigal 2025 | `wizenty2025principles` | See §1. |
| Mouse gastric surface epithelium early-infection study *(to complete)* | — | Host response context for the alpha-diversity comparison. |

## 7. Methods & software

| Work | Key |
|------|-----|
| R | `rcoreteam` |
| meta-analysis tutorial (Balduzzi et al. 2019) | `balduzzi2019meta` |
| metafor (Viechtbauer 2010) | `viechtbauer2010metafor` |
| gtsummary (Sjoberg et al. 2021) | `gtsummary` |
| gt | `gt` |
| ggplot2 | `ggplot2` |

---

### Maintenance

- Add new items to `references.bib` first, then link them here.
- Resolve every *(to complete)* before manuscript submission.
- Keep §3 aligned with the studies actually entered into
  `data/raw/CentralAsia_Hpylori_*.csv` for the meta-analysis.
