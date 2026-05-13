#!/usr/bin/env python3
"""Fetch publications from WoS + InCites and save as JSON for the resume."""

import json
import sys
from datetime import datetime
from pathlib import Path

sys.path.insert(0, str(Path(__file__).parent))
from wos_api import get_publications, fetch_cnci, calc_h_index, calc_m_index

EXCLUDE_JOURNALS = [
    "ACU Research Bank",
    "BehaviourWorks Australia",
    "The Health & Fitness Journal of Canada",
]

# WoS records misattributed to this ORCID (someone else's paper carrying the wrong AI tag).
# Fix upstream at orcid.org or by filing a WoS record correction; entries here are a backstop.
EXCLUDE_UTS = {
    "WOS:001179439900001",  # Gallo, Daniele (2023). Article 267 TFEU. Eur. J. Legal Studies.
}

JOURNAL_RENAMES = {
    "BMJ-BRITISH MEDICAL JOURNAL": "bmj",
}


def main():
    pubs, _ = get_publications(orcid="0000-0002-6563-8203", use_cache=True)

    # Filter out errata, excluded venues, and misattributed records
    pubs = [
        p for p in pubs
        if p["doc_type"] != "Correction"
        and p["journal"] not in EXCLUDE_JOURNALS
        and p["wos_ut"] not in EXCLUDE_UTS
        and p["year"] is not None
    ]

    # Fetch CNCI data from InCites
    uts = [p["wos_ut"] for p in pubs]
    print(f"Fetching CNCI for {len(uts)} publications...")
    cnci_data = fetch_cnci(uts)
    print(f"Got CNCI data for {len(cnci_data)} publications")

    # Merge CNCI into publication records
    for p in pubs:
        metrics = cnci_data.get(p["wos_ut"], {})
        p["cnci"] = metrics.get("cnci")
        p["percentile"] = metrics.get("percentile")
        p["impact_factor"] = metrics.get("impact_factor")
        p["hot_paper"] = metrics.get("hot_paper", False)
        p["esi_most_cited"] = metrics.get("esi_most_cited", False)

    # Apply journal renames
    for p in pubs:
        if p["journal"] in JOURNAL_RENAMES:
            p["journal"] = JOURNAL_RENAMES[p["journal"]]

    # Sort by year (desc), then citations (desc)
    pubs.sort(key=lambda x: (-x["year"], -x["cites"]))

    # Calculate metrics
    cites_list = [p["cites"] for p in pubs]
    h_index = calc_h_index(cites_list)
    m_index = calc_m_index(h_index)
    total_citations = sum(cites_list)

    # CNCI metrics
    cnci_values = [p["cnci"] for p in pubs if p["cnci"] is not None]
    mean_cnci = round(sum(cnci_values) / len(cnci_values), 2) if cnci_values else None

    # % papers in top 10% (percentile >= 90)
    percentiles = [p["percentile"] for p in pubs if p["percentile"] is not None]
    pct_top10 = round(
        100 * sum(1 for pct in percentiles if pct >= 90) / len(percentiles), 1
    ) if percentiles else None

    output = {
        "publications": pubs,
        "metrics": {
            "h_index": h_index,
            "m_index": m_index,
            "total_citations": total_citations,
            "n_pubs": len(pubs),
            "mean_cnci": mean_cnci,
            "pct_top10": pct_top10,
        },
        "fetched_at": datetime.now().isoformat(),
        "source": "Web of Science",
    }

    out_path = Path(__file__).parent / "publications.json"
    with open(out_path, "w") as f:
        json.dump(output, f, indent=2, default=str)

    print(f"\nSaved {len(pubs)} publications to {out_path}")
    print(f"h-index: {h_index}")
    print(f"m-index: {m_index}")
    print(f"Total citations: {total_citations}")
    print(f"Mean CNCI: {mean_cnci}")
    print(f"% papers in top 10%: {pct_top10}%")


if __name__ == "__main__":
    main()
