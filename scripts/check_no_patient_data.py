#!/usr/bin/env python3
"""Block participant-level data from entering git history.

Runs as a pre-commit hook over the files staged for commit. Three checks:

  1. Tabular/binary data files outside the three directories that are tracked
     on purpose (data/meta/, data/templates/, results/meta-analysis/).
  2. Cohort identifier column headers appearing in any staged text file --
     catches a CSV renamed to .md, pasted into a script, or force-added.
  3. Oversized files, which in this repository almost always means data.

Exit status 1 fails the commit. Override only with a documented reason:
    SKIP=no-patient-data git commit ...
"""
from __future__ import annotations

import csv
import io
import subprocess
import sys
from pathlib import Path

# Directories whose data files are tracked deliberately (aggregate, no individuals).
ALLOWED_DATA_DIRS = (
    "data/meta/",
    "data/templates/",
    "results/meta-analysis/",
)

# Extensions that should never appear outside the allowed directories.
DATA_EXTENSIONS = {
    ".csv", ".tsv", ".txt", ".xlsx", ".xls", ".xlsm",
    ".rds", ".rdata", ".sav", ".dta", ".feather", ".parquet",
    ".fastq", ".fq", ".bam", ".sam", ".vcf", ".biom", ".qza", ".qzv",
}

# Identifier / quasi-identifier headers from the cohort spreadsheet.
# See docs/data-dictionary.md. Presence of several together means records.
IDENTIFIER_HEADERS = {
    "id", "nationality", "age", "sex", "pylori_stock",
    "ras_result", "culture", "endoscopy", "dna_conc", "sequencing_done",
}
IDENTIFIER_HIT_THRESHOLD = 4  # this many distinct headers in one row = a record table

MAX_BYTES = 2_000_000  # 2 MB; the largest legitimate file in this repo is ~10 KB

TEXT_SUFFIXES = {".md", ".r", ".rmd", ".py", ".sh", ".yml", ".yaml", ".json", ".bib", ".txt"}


def staged_files() -> list[str]:
    out = subprocess.run(
        ["git", "diff", "--cached", "--name-only", "--diff-filter=ACM"],
        capture_output=True, text=True, check=True,
    ).stdout
    return [line for line in out.splitlines() if line.strip()]


def is_allowed_data_path(path: str) -> bool:
    return any(path.startswith(d) for d in ALLOWED_DATA_DIRS)


def header_hits(path: Path) -> int:
    """Count distinct cohort identifier headers in the first few lines."""
    try:
        head = path.read_text(encoding="utf-8", errors="ignore")[:8192]
    except OSError:
        return 0
    best = 0
    for line in head.splitlines()[:5]:
        for delim in (",", "\t", ";"):
            if delim not in line:
                continue
            try:
                fields = next(csv.reader(io.StringIO(line), delimiter=delim))
            except csv.Error:
                continue
            names = {f.strip().strip('"').lower() for f in fields}
            best = max(best, len(names & IDENTIFIER_HEADERS))
    return best


def main() -> int:
    problems: list[str] = []

    for name in staged_files():
        path = Path(name)
        suffix = path.suffix.lower()

        if suffix in DATA_EXTENSIONS and not is_allowed_data_path(name):
            problems.append(
                f"{name}: data file outside "
                f"{', '.join(ALLOWED_DATA_DIRS)} -- participant data must not be committed"
            )
            continue

        if not path.exists():
            continue

        try:
            size = path.stat().st_size
        except OSError:
            size = 0
        if size > MAX_BYTES:
            problems.append(f"{name}: {size:,} bytes exceeds the {MAX_BYTES:,}-byte limit")

        # Header scan: any text-ish file, plus the allowed CSV dirs (a template
        # is header-only; a template with records in it is a leak).
        if suffix in TEXT_SUFFIXES or suffix in {".csv", ".tsv"}:
            hits = header_hits(path)
            if hits >= IDENTIFIER_HIT_THRESHOLD:
                if name.startswith("data/templates/"):
                    # Header-only by contract: allow the header, reject records.
                    try:
                        lines = [ln for ln in path.read_text(
                            encoding="utf-8", errors="ignore").splitlines() if ln.strip()]
                    except OSError:
                        lines = []
                    if len(lines) > 1:
                        problems.append(
                            f"{name}: template must be header-only, found "
                            f"{len(lines) - 1} data row(s)"
                        )
                else:
                    problems.append(
                        f"{name}: contains {hits} cohort identifier column headers "
                        f"(ID/Age/Sex/Nationality/...) -- looks like participant records"
                    )

    if problems:
        sys.stderr.write("\nBlocked: this commit looks like it contains participant data.\n\n")
        for p in problems:
            sys.stderr.write(f"  - {p}\n")
        sys.stderr.write(
            "\nSee docs/ethics.md. If this is a false positive, unstage the file or run:\n"
            "  SKIP=no-patient-data git commit ...\n\n"
        )
        return 1
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
