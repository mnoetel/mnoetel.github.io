"""Web of Science + InCites API client for fetching publication data."""

import os
import json
import requests
from datetime import datetime
from pathlib import Path

WOS_API_BASE = "https://wos-api.clarivate.com/api/wos"
INCITES_API_BASE = "https://incites-api.clarivate.com/api/incites"
CACHE_FILE = Path(__file__).parent / ".wos_cache.json"


def _parse_renviron():
    """Parse ~/.Renviron file for key=value pairs."""
    renviron = Path.home() / ".Renviron"
    env = {}
    if renviron.exists():
        for line in renviron.read_text().splitlines():
            line = line.strip()
            if "=" in line and not line.startswith("#"):
                key, val = line.split("=", 1)
                env[key.strip()] = val.strip().strip("'\"")
    return env


def get_wos_api_key():
    key = os.environ.get("WOS_API_KEY")
    if not key:
        key = _parse_renviron().get("WOS_API_KEY")
    if not key:
        raise EnvironmentError("WOS_API_KEY not found in environment or ~/.Renviron")
    return key


def get_incites_api_key():
    key = os.environ.get("INCITES_API_KEY")
    if not key:
        key = _parse_renviron().get("INCITES_API_KEY")
    if not key:
        raise EnvironmentError("INCITES_API_KEY not found in environment or ~/.Renviron")
    return key


def fetch_author_publications(orcid="0000-0002-6563-8203"):
    """Fetch all publications for an author from WoS Expanded API using ORCID."""
    api_key = get_wos_api_key()
    headers = {"X-ApiKey": api_key, "Accept": "application/json"}

    query = f"AI=({orcid})"
    all_records = []
    first_record = 1
    count = 100

    while True:
        params = {
            "databaseId": "WOS",
            "usrQuery": query,
            "count": count,
            "firstRecord": first_record,
        }
        resp = requests.get(WOS_API_BASE, headers=headers, params=params)
        resp.raise_for_status()
        data = resp.json()

        query_result = data.get("QueryResult", {})
        total_records = query_result.get("RecordsFound", 0)

        if total_records == 0:
            break

        records = data.get("Data", {}).get("Records", {}).get("records", {}).get("REC", [])
        if not records:
            break

        if isinstance(records, dict):
            records = [records]

        all_records.extend(records)

        if first_record + count > total_records:
            break
        first_record += count

    return all_records


def parse_wos_record(rec):
    """Extract key fields from a single WoS Expanded API record."""
    uid = rec.get("UID", "")
    static = rec.get("static_data", {})
    dynamic = rec.get("dynamic_data", {})

    # Title
    titles = static.get("summary", {}).get("titles", {}).get("title", [])
    if isinstance(titles, dict):
        titles = [titles]
    item_title = next((t.get("content", "") for t in titles if t.get("type") == "item"), "")
    source_title = next((t.get("content", "") for t in titles if t.get("type") == "source"), "")

    # Authors
    names = static.get("summary", {}).get("names", {}).get("name", [])
    if isinstance(names, dict):
        names = [names]
    first_author = names[0].get("display_name", "") if names else ""

    # Publication year
    pub_info = static.get("summary", {}).get("pub_info", {})
    year = pub_info.get("pubyear", "")

    # DOI - check identifiers in cluster_related
    doi = ""
    identifiers = dynamic.get("cluster_related", {}).get("identifiers", {}).get("identifier", [])
    if isinstance(identifiers, dict):
        identifiers = [identifiers]
    for ident in identifiers:
        if ident.get("type", "").lower() == "doi":
            doi = ident.get("value", "")
            break

    # Also check static_data identifiers if DOI not found
    if not doi:
        static_ids = static.get("item", {}).get("ids", {}).get("identifier", [])
        if isinstance(static_ids, dict):
            static_ids = [static_ids]
        for ident in static_ids:
            if ident.get("type", "").lower() == "doi":
                doi = ident.get("value", "")
                break

    # Times cited
    times_cited = 0
    tc_list = dynamic.get("citation_related", {}).get("tc_list", {}).get("silo_tc", [])
    if isinstance(tc_list, dict):
        tc_list = [tc_list]
    for tc in tc_list:
        if tc.get("coll_id") == "WOS":
            times_cited = int(tc.get("local_count", 0))
            break

    # Document type
    doc_types = static.get("summary", {}).get("doctypes", {}).get("doctype", [])
    if isinstance(doc_types, str):
        doc_types = [doc_types]
    doc_type = doc_types[0] if doc_types else ""

    return {
        "wos_ut": uid,
        "title": item_title,
        "journal": source_title,
        "doi": doi,
        "cites": times_cited,
        "first_author": first_author,
        "year": int(year) if year else None,
        "doc_type": doc_type,
    }


def fetch_cnci(ut_list):
    """Fetch CNCI (Category Normalized Citation Impact) from InCites API.

    Returns a dict mapping WoS UT (with WOS: prefix) -> dict of InCites metrics.
    InCites requires UTs WITHOUT the 'WOS:' prefix.
    InCites accepts up to 100 UTs per request.
    """
    api_key = get_incites_api_key()
    headers = {"X-ApiKey": api_key, "Accept": "application/json"}
    cnci_map = {}

    # Strip WOS: prefix for InCites API
    stripped = {ut.replace("WOS:", ""): ut for ut in ut_list}

    # Process in batches of 100
    batch_keys = list(stripped.keys())
    for i in range(0, len(batch_keys), 100):
        batch = batch_keys[i : i + 100]
        ut_param = ",".join(batch)

        resp = requests.get(
            f"{INCITES_API_BASE}/DocumentLevelMetricsByUT/json",
            headers=headers,
            params={"UT": ut_param},
        )
        resp.raise_for_status()
        data = resp.json()

        # Response structure: {"api": [{"name": "...", "rval": [...]}]}
        rval = []
        for api_entry in data.get("api", []):
            rval.extend(api_entry.get("rval", []))

        for rec in rval:
            if isinstance(rec, dict):
                isi_loc = rec.get("ISI_LOC", "")
                original_ut = stripped.get(isi_loc, f"WOS:{isi_loc}")
                cnci_val = rec.get("NCI")  # NCI = Normalized Citation Impact (CNCI)
                percentile = rec.get("PERCENTILE")
                impact_factor = rec.get("IMPACT_FACTOR")
                tot_cites = rec.get("TOT_CITES")
                hot_paper = rec.get("HOT_PAPER")
                esi_cited = rec.get("ESI_MOST_CITED_ARTICLE")

                metrics = {}
                if cnci_val is not None:
                    try:
                        metrics["cnci"] = round(float(cnci_val), 2)
                    except (ValueError, TypeError):
                        pass
                if percentile is not None:
                    try:
                        metrics["percentile"] = round(float(percentile), 2)
                    except (ValueError, TypeError):
                        pass
                if impact_factor is not None:
                    try:
                        metrics["impact_factor"] = float(impact_factor)
                    except (ValueError, TypeError):
                        pass
                if tot_cites is not None:
                    try:
                        metrics["incites_cites"] = int(tot_cites)
                    except (ValueError, TypeError):
                        pass
                if hot_paper == "1":
                    metrics["hot_paper"] = True
                if esi_cited == "1":
                    metrics["esi_most_cited"] = True

                cnci_map[original_ut] = metrics

    return cnci_map


def calc_h_index(cites):
    """Calculate h-index from a list of citation counts."""
    sorted_cites = sorted(cites, reverse=True)
    h = 0
    for i, c in enumerate(sorted_cites):
        if c >= i + 1:
            h = i + 1
        else:
            break
    return h


def calc_m_index(h_index, first_pub_date="2019-05-10"):
    """Calculate m-index (h-index / academic career years)."""
    start = datetime.strptime(first_pub_date, "%Y-%m-%d")
    years = (datetime.now() - start).days / 365.25
    return round(h_index / years, 1) if years > 0 else 0


def load_cache():
    """Load cached API data if fresh (< 24 hours old)."""
    if CACHE_FILE.exists():
        with open(CACHE_FILE) as f:
            cache = json.load(f)
        cached_at = datetime.fromisoformat(cache.get("cached_at", "2000-01-01"))
        if (datetime.now() - cached_at).total_seconds() < 86400:
            return cache.get("records")
    return None


def save_cache(records):
    """Save raw API records to cache file."""
    with open(CACHE_FILE, "w") as f:
        json.dump({"cached_at": datetime.now().isoformat(), "records": records}, f)


def get_publications(orcid="0000-0002-6563-8203", use_cache=True):
    """Main entry point: fetch publications with optional caching.

    Returns (list_of_parsed_records, raw_records).
    """
    if use_cache:
        cached = load_cache()
        if cached is not None:
            print(f"Using cached data ({len(cached)} records)")
            parsed = [parse_wos_record(r) for r in cached]
            return parsed, cached

    print("Fetching from WoS Expanded API...")
    raw_records = fetch_author_publications(orcid=orcid)
    print(f"Found {len(raw_records)} records")
    save_cache(raw_records)

    parsed = [parse_wos_record(r) for r in raw_records]
    return parsed, raw_records
