#!/usr/bin/env python3
"""Run a range of corpus formulas through dnaonecalc-host verify-batch and report results."""

import argparse
import json
import os
import signal
import subprocess
import sys
import time
from pathlib import Path

# Force UTF-8 output on Windows
if sys.platform == "win32":
    sys.stdout.reconfigure(encoding="utf-8", errors="replace")
    sys.stderr.reconfigure(encoding="utf-8", errors="replace")

CORPUS_PATH = Path(__file__).parent.parent / "formula" / "single-cell" / "formulas.jsonl"
DNAONECALC_ROOT = Path(__file__).resolve().parent.parent.parent.parent.parent / "DnaOneCalc"
RESULTS_ROOT = Path(__file__).parent / "results"

# ANSI colors
RED = "\033[91m"
GREEN = "\033[92m"
YELLOW = "\033[93m"
CYAN = "\033[96m"
DIM = "\033[2m"
BOLD = "\033[1m"
RESET = "\033[0m"


def load_corpus(path: Path) -> list[dict]:
    entries = []
    with open(path, "r", encoding="utf-8") as f:
        for line in f:
            line = line.strip()
            if line:
                entries.append(json.loads(line))
    return entries


def select_range(entries: list[dict], range_spec: str) -> list[dict]:
    """Select entries by range spec: '1-20', '5', '10-', '-50', or 'FTC-0001-FTC-0020'."""
    # Try FTC-id range
    if range_spec.startswith("FTC-"):
        parts = range_spec.split("-FTC-")
        if len(parts) == 2:
            start_id = "FTC-" + parts[0].removeprefix("FTC-")
            end_id = "FTC-" + parts[1]
            collecting = False
            result = []
            for e in entries:
                if e["test_id"] == start_id:
                    collecting = True
                if collecting:
                    result.append(e)
                if e["test_id"] == end_id:
                    break
            return result
        else:
            # Single FTC id
            return [e for e in entries if e["test_id"] == range_spec]

    # Numeric range (1-based)
    if "-" in range_spec:
        parts = range_spec.split("-", 1)
        start = int(parts[0]) if parts[0] else 1
        end = int(parts[1]) if parts[1] else len(entries)
        return entries[start - 1 : end]
    else:
        idx = int(range_spec)
        return entries[idx - 1 : idx]


def build_batch_json(cases: list[dict], excel: bool) -> dict:
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
                "case_id": e["test_id"],
                "entered_cell_text": e["formula"],
                "spreadsheet_xml_source": None,
            }
            for e in cases
        ],
    }


def run_batch(batch_json: dict, output_dir: Path, dnaonecalc_root: Path) -> dict | None:
    """Run verify-batch and return the parsed report."""
    batch_file = output_dir / "input-batch.json"
    output_dir.mkdir(parents=True, exist_ok=True)
    batch_file.write_text(json.dumps(batch_json, indent=2), encoding="utf-8")

    case_count = len(batch_json.get("cases", []))
    batch_timeout = max(600, case_count * 30)  # 30s per formula, minimum 10 min

    cmd = [
        "cargo", "run", "-p", "dnaonecalc-host", "--",
        "verify-batch",
        "--input", str(batch_file),
        "--output-root", str(output_dir),
    ]

    proc = subprocess.run(
        cmd,
        cwd=str(dnaonecalc_root),
        capture_output=True,
        text=True,
        timeout=batch_timeout,
    )

    # Print stderr for build progress (but filter noise)
    for line in proc.stderr.splitlines():
        if "warning: output filename collision" in line or line.strip().startswith("= note:"):
            continue
        if line.strip():
            print(f"{DIM}{line}{RESET}", file=sys.stderr)

    report_path = output_dir / "verification-bundle-report.json"
    if report_path.exists():
        return json.loads(report_path.read_text(encoding="utf-8"))

    return None


def _kill_proc_tree(pid: int):
    """Kill a process and all its children. Works on Windows and Unix."""
    if sys.platform == "win32":
        # taskkill /T kills the entire process tree
        subprocess.run(
            ["taskkill", "/F", "/T", "/PID", str(pid)],
            capture_output=True,
        )
    else:
        try:
            os.killpg(os.getpgid(pid), signal.SIGKILL)
        except (ProcessLookupError, PermissionError):
            pass


def _make_error_report(case_id: str, formula: str, status: str, detail: str) -> dict:
    return {
        "case_id": case_id,
        "entered_cell_text": formula,
        "comparison_status": status,
        "oxfml_summary": {"evaluation_summary": detail},
        "excel_summary": {},
        "discrepancy_summary": detail,
        "replay_mismatch_kinds": [],
        "replay_mismatch_records": [],
        "replay_explain_records": [],
    }


def run_single(case: dict, output_dir: Path, dnaonecalc_root: Path, excel: bool,
               timeout: int = 30) -> dict:
    """Run verify-formula for a single case with robust timeout handling."""
    case_id = case["test_id"]
    formula = case["formula"]
    case_dir = output_dir / "cases" / case_id

    cmd = [
        "cargo", "run", "-p", "dnaonecalc-host", "--",
        "verify-formula",
        "--case-id", case_id,
        "--formula", formula,
        "--output-root", str(case_dir),
    ]

    # Use Popen so we can kill the process tree on timeout
    creation_flags = subprocess.CREATE_NEW_PROCESS_GROUP if sys.platform == "win32" else 0
    preexec = None if sys.platform == "win32" else os.setsid

    try:
        proc = subprocess.Popen(
            cmd,
            cwd=str(dnaonecalc_root),
            stdout=subprocess.PIPE,
            stderr=subprocess.PIPE,
            text=True,
            creationflags=creation_flags,
            preexec_fn=preexec,
        )
    except Exception as e:
        return _make_error_report(case_id, formula, "OxFmlError", f"Failed to start: {e}")

    try:
        stdout, stderr = proc.communicate(timeout=timeout)
    except subprocess.TimeoutExpired:
        _kill_proc_tree(proc.pid)
        try:
            proc.communicate(timeout=5)
        except subprocess.TimeoutExpired:
            proc.kill()
        return _make_error_report(case_id, formula, "Timeout", f"Timed out after {timeout}s")

    # Try to read the comparison summary from the case output
    report_path = case_dir / "verification-bundle-report.json"
    if report_path.exists():
        report = json.loads(report_path.read_text(encoding="utf-8"))
        case_reports = report.get("case_reports", [])
        if case_reports:
            return case_reports[0]

    # Parse failure or other hard error — extract message from stderr
    err_detail = ""
    for line in (stderr or "").splitlines():
        if "OxFml runtime execution failed" in line or "formula execution rejected" in line:
            err_detail = line.strip()
            break

    return _make_error_report(case_id, formula, "OxFmlError",
                              err_detail or f"exit code {proc.returncode}")


def run_resilient(cases: list[dict], output_dir: Path, dnaonecalc_root: Path, excel: bool,
                   timeout: int = 30) -> dict:
    """Try batch first; if it fails, fall back to one-at-a-time execution."""
    batch_json = build_batch_json(cases, excel=excel)
    report = run_batch(batch_json, output_dir, dnaonecalc_root)
    if report is not None:
        return report

    # Batch failed — run individually
    print(f"{YELLOW}Batch failed, falling back to individual execution...{RESET}", file=sys.stderr)
    case_reports = []
    timeouts = 0
    for i, case in enumerate(cases):
        sys.stderr.write(f"\r{DIM}  [{i+1}/{len(cases)}] {case['test_id']}: {case['formula'][:40]:<40}{RESET}")
        sys.stderr.flush()
        result = run_single(case, output_dir, dnaonecalc_root, excel, timeout=timeout)
        case_reports.append(result)
        if result["comparison_status"] == "Timeout":
            timeouts += 1
            if timeouts >= 3:
                print(f"\n{RED}3 consecutive-area timeouts — possible systemic hang. Stopping early.{RESET}",
                      file=sys.stderr)
                # Mark remaining as skipped
                for remaining in cases[i+1:]:
                    case_reports.append(_make_error_report(
                        remaining["test_id"], remaining["formula"], "Skipped",
                        "Skipped after repeated timeouts"))
                break
        else:
            timeouts = 0  # reset on success
    sys.stderr.write("\n")

    return {"case_reports": case_reports}


def print_report(report: dict, corpus_lookup: dict[str, dict]):
    """Print a summary table highlighting failures."""
    cases = report.get("case_reports", [])
    matched = 0
    mismatched = 0
    errors = 0

    print()
    print(f"{BOLD}{'ID':<12} {'Status':<12} {'OxFml':<24} {'Excel':<24} Formula{RESET}")
    print("-" * 100)

    for c in cases:
        case_id = c["case_id"]
        status = c["comparison_status"]
        formula = c["entered_cell_text"]
        oxfml = c.get("oxfml_summary") or {}
        excel = c.get("excel_summary") or {}
        oxfml_val = oxfml.get("effective_display_summary", oxfml.get("evaluation_summary", "?"))
        excel_val = excel.get("observed_value_repr", "?")

        # Truncate long values
        if len(str(oxfml_val)) > 22:
            oxfml_val = str(oxfml_val)[:19] + "..."
        if len(str(excel_val)) > 22:
            excel_val = str(excel_val)[:19] + "..."
        if len(formula) > 40:
            formula_display = formula[:37] + "..."
        else:
            formula_display = formula

        if status == "Matched":
            matched += 1
            color = GREEN
            marker = "  "
        elif status == "Mismatched":
            mismatched += 1
            color = RED
            marker = "X "
        elif status == "Timeout":
            errors += 1
            color = YELLOW
            marker = "T "
        elif status == "Skipped":
            errors += 1
            color = DIM
            marker = "- "
        elif status == "OxFmlError":
            errors += 1
            color = YELLOW
            marker = "! "
        else:
            errors += 1
            color = YELLOW
            marker = "? "

        print(f"{color}{marker}{case_id:<10} {status:<12} {str(oxfml_val):<24} {str(excel_val):<24} {formula_display}{RESET}")

        # Show discrepancy details for failures
        if status == "Mismatched":
            disc = c.get("discrepancy_summary")
            if disc:
                # Show a concise version
                for part in disc.split(" | "):
                    print(f"  {RED}{DIM}  └─ {part}{RESET}")

    print("-" * 100)
    total = matched + mismatched + errors
    print(f"\n{BOLD}Total: {total}  {GREEN}Matched: {matched}{RESET}  {RED}{BOLD}Mismatched: {mismatched}{RESET}  {YELLOW}{BOLD}Errors: {errors}{RESET}")

    if mismatched > 0:
        print(f"\n{RED}{BOLD}FAILURES:{RESET}")
        for c in cases:
            if c["comparison_status"] == "Mismatched":
                oxfml = c.get("oxfml_summary", {})
                excel = c.get("excel_summary", {})
                print(f"  {RED}{c['case_id']}{RESET}: {c['entered_cell_text']}")
                print(f"    OxFml: {oxfml.get('evaluation_summary', '?')}")
                print(f"    Excel: {excel.get('observed_value_repr', '?')}")
                blocked = oxfml.get("blocked_reason")
                if blocked:
                    print(f"    {YELLOW}Blocked: {blocked}{RESET}")
                print()

    return mismatched


def main():
    parser = argparse.ArgumentParser(
        description="Run corpus formula range through dnaonecalc-host",
        epilog="Range examples: 1-20, 5, 10-, -50, FTC-0001-FTC-0020",
    )
    parser.add_argument("range", help="Range spec: 1-20, FTC-0001-FTC-0050, etc.")
    parser.add_argument("--corpus", type=Path, default=CORPUS_PATH)
    parser.add_argument("--dnaonecalc", type=Path, default=DNAONECALC_ROOT)
    parser.add_argument("--output", type=Path, default=None, help="Output dir (default: results/<range>)")
    parser.add_argument("--excel", action="store_true", default=True, help="Enable Excel observation (default)")
    parser.add_argument("--no-excel", action="store_true", help="OxFml-only mode")
    parser.add_argument("--category", type=str, default=None, help="Filter by category before applying range")
    parser.add_argument("--exclude", type=str, default=None, help="Comma-separated test IDs to skip")
    parser.add_argument("--timeout", type=int, default=30, help="Timeout per formula in seconds (default: 30)")
    args = parser.parse_args()

    excel = args.excel and not args.no_excel
    output_dir = args.output or RESULTS_ROOT / args.range.replace("-", "_")
    exclude_ids = set(args.exclude.split(",")) if args.exclude else set()

    # Load and filter
    corpus = load_corpus(args.corpus)
    if args.category:
        corpus = [e for e in corpus if e.get("category") == args.category]

    selected = select_range(corpus, args.range)
    if exclude_ids:
        skipped = [e for e in selected if e["test_id"] in exclude_ids]
        selected = [e for e in selected if e["test_id"] not in exclude_ids]
        for s in skipped:
            print(f"{YELLOW}Excluding {s['test_id']}: {s['formula']}{RESET}")
    if not selected:
        print(f"{RED}No formulas matched range '{args.range}'{RESET}", file=sys.stderr)
        sys.exit(1)

    # Build lookup for later
    corpus_lookup = {e["test_id"]: e for e in corpus}

    print(f"{CYAN}Running {len(selected)} formulas ({selected[0]['test_id']} .. {selected[-1]['test_id']}){RESET}")
    print(f"{DIM}Output: {output_dir}{RESET}")
    print(f"{DIM}Mode: {'OxFml + Excel' if excel else 'OxFml only'}{RESET}")

    start = time.time()
    report = run_resilient(selected, output_dir, args.dnaonecalc, excel, timeout=args.timeout)
    elapsed = time.time() - start

    failures = print_report(report, corpus_lookup)
    print(f"\n{DIM}Elapsed: {elapsed:.1f}s ({elapsed / len(selected):.2f}s/formula){RESET}")

    sys.exit(1 if failures > 0 else 0)


if __name__ == "__main__":
    main()
