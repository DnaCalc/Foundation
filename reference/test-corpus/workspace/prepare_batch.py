#!/usr/bin/env python3
"""Convert Foundation corpus JSONL into DnaOneCalc verify-batch input JSON."""

import argparse
import json
import sys
from pathlib import Path

CORPUS_PATH = Path(__file__).parent.parent / "formula" / "single-cell" / "formulas.jsonl"


def load_corpus(path: Path):
    with open(path, "r", encoding="utf-8") as f:
        for line in f:
            line = line.strip()
            if line:
                yield json.loads(line)


def build_batch(cases, *, excel: bool) -> dict:
    return {
        "host_profile": {
            "profile_id": "windows_excel_default" if excel else "oxfml_only",
            "requires_excel_observation": excel,
        },
        "capabilities": {
            "host_summary": "windows_native_excel_default" if excel else "oxfml_only",
            "excel_observation_available": excel,
        },
        "cases": [
            {
                "case_id": c["test_id"],
                "entered_cell_text": c["formula"],
                "spreadsheet_xml_source": None,
            }
            for c in cases
        ],
    }


def main():
    parser = argparse.ArgumentParser(description="Prepare verify-batch input from corpus JSONL")
    parser.add_argument("--corpus", type=Path, default=CORPUS_PATH, help="Path to formulas.jsonl")
    parser.add_argument("--limit", type=int, default=None, help="Take only the first N formulas")
    parser.add_argument("--offset", type=int, default=0, help="Skip the first N formulas before applying --limit")
    parser.add_argument("--category", type=str, default=None, help="Filter to a specific category")
    parser.add_argument("--tags", type=str, default=None, help="Comma-separated tags (match any)")
    parser.add_argument("--deterministic-only", action="store_true", help="Exclude non-deterministic formulas")
    parser.add_argument("--excel", action="store_true", help="Enable Excel observation")
    parser.add_argument("--no-excel", action="store_true", help="Disable Excel observation (default)")
    parser.add_argument("-o", "--output", type=Path, default=None, help="Output file (default: stdout)")
    args = parser.parse_args()

    excel = args.excel and not args.no_excel
    tag_set = set(args.tags.split(",")) if args.tags else None

    entries = list(load_corpus(args.corpus))

    # Apply filters
    if args.category:
        entries = [e for e in entries if e.get("category") == args.category]
    if tag_set:
        entries = [e for e in entries if tag_set & set(e.get("tags", []))]
    if args.deterministic_only:
        entries = [e for e in entries if e.get("deterministic", True)]
    if args.offset:
        entries = entries[args.offset :]
    if args.limit:
        entries = entries[: args.limit]

    batch = build_batch(entries, excel=excel)

    output_json = json.dumps(batch, indent=2, ensure_ascii=False)

    if args.output:
        args.output.parent.mkdir(parents=True, exist_ok=True)
        args.output.write_text(output_json, encoding="utf-8")
        print(f"Wrote {len(entries)} cases to {args.output}", file=sys.stderr)
    else:
        print(output_json)


if __name__ == "__main__":
    main()
