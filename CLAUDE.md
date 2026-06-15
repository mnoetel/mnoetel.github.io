# CLAUDE.md

Personal site (Jekyll / beautiful-jekyll) for Michael Noetel, served at mnoetel.github.io.
Most active work lives in `resume_code/`, which builds the CV from live citation data.

## Updating citations / rebuilding the CV

The CV's publication list and citation metrics are pulled live from **Web of Science**
(+ InCites for CNCI) and rendered with **Typst**. To refresh everything:

```bash
cd resume_code && ./build.sh
```

`build.sh` runs `fetch_publications.py` → compiles `mnoetel_resume.typ` to
`mnoetel_resume.pdf` → copies the PDF to the repo root (the version the site links to).

- **API keys** (`WOS_API_KEY`, `INCITES_API_KEY`) are read from `~/.Renviron` (or the
  environment) by `wos_api.py`.
- Publications are fetched by ORCID `0000-0002-6563-8203`; raw API responses are cached in
  `resume_code/.wos_cache.json` for 24h, so re-running within a day reuses the cache and
  makes **no** API calls. Delete the cache to force a fresh pull.
- Fetched data and computed metrics (h-index, m-index, total citations, mean CNCI,
  % top-10%) land in `resume_code/publications.json`, which the Typst template reads.

## Data-quality gotchas (read before trusting a refresh)

- **WoS Core citation counts can glitch low during re-indexing.** A single record's
  times-cited can collapse far below the true value (cross-check against InCites
  `TOT_CITES` and the paper's ESI / CNCI status). When this happens, pin the last-known-good
  value in `CITES_OVERRIDE` in `fetch_publications.py`. The override logs a WARNING and stops
  applying once the live count climbs back above it, so remove stale entries.
  - *History:* the 2024 *BMJ* exercise-for-depression NMA (`WOS:001195817800009`) reported
    398 cites in May 2026, then 59 on 2026-06-16 (InCites said 347 the same day) — overridden
    back to 398.
- `EXCLUDE_UTS` drops records misattributed to the ORCID; `EXCLUDE_JOURNALS` drops
  non-scholarly venues; `JOURNAL_RENAMES` fixes display names. All in `fetch_publications.py`.
- After any refresh, sanity-check the diff vs. the previous `publications.json` — total
  citations should generally only go **up** month-over-month; a drop usually means a glitch.

## Resume rendering (`mnoetel_resume.typ`)

- Per-paper metrics line shows citation count (when > 10) and CNCI (when > 1).
- Papers flagged `esi_most_cited` (ESI "Highly Cited" — top 1% by citations for their field
  & year) get a **★ Top 1% cited (ESI)** prestige badge in the accent colour.
- Headline "Metrics of excellence" line and the Publications section header both report
  total citations (formatted with the `thousands()` helper).
- Accent colour is `#053C45`.
