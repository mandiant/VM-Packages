import json
import os
import sys
from datetime import datetime


def main():
    repo_root = os.path.abspath(os.path.join(os.path.dirname(__file__), "../.."))
    artifacts_dir = os.path.join(repo_root, "downloaded_artifacts")  # GitHub downloads to a folder
    result_file = "success_failure.json"  # The final combined file for the badge step
    log_file = "wiki/Daily-Failures.md"

    if not os.path.exists(artifacts_dir):
        print(f"Error: artifacts directory not found at {artifacts_dir}", file=sys.stderr)
        sys.exit(1)

    # Group results by OS alias (e.g., Win10, Win11)
    os_results = {}

    for dirpath, _, filenames in os.walk(artifacts_dir):
        folder_name = os.path.basename(dirpath)
        if not folder_name.startswith("success_failure_"):
            continue

        parts = folder_name.split("_")
        os_alias = "Unknown"
        if len(parts) >= 3:
            # Name format: success_failure_Win10_0
            os_alias = parts[2]

        if os_alias not in os_results:
            os_results[os_alias] = {"success": 0, "failure": 0, "failures": []}

        for filename in filenames:
            if filename == "success_failure.json":
                filepath = os.path.join(dirpath, filename)
                try:
                    with open(filepath) as f:
                        data = json.load(f)
                        os_results[os_alias]["success"] += data.get("success", 0)
                        os_results[os_alias]["failure"] += data.get("failure", 0)
                        os_results[os_alias]["failures"].extend(data.get("failures", []))
                except Exception as e:
                    print(f"Warn: Failed to read {filename} in {dirpath}: {e}", file=sys.stderr)

    if not os_results:
        print("No results found to combine!")
        sys.exit(0)

    # Sum totals for a single combined JSON (optional, but keeps the file format consistent for badges)
    total_success = sum(r["success"] for r in os_results.values())
    total_failed = sum(r["failure"] for r in os_results.values())
    total_packages = total_success + total_failed
    all_failures = []
    for r in os_results.values():
        all_failures.extend(r["failures"])

    # Write combined JSON for the badge step
    final_result = {
        "success": total_success,
        "failure": total_failed,
        "total": total_packages,
        "failures": all_failures,
    }
    with open(result_file, "w") as f:
        json.dump(final_result, f, indent=4)

    url = f"https://github.com/{os.environ.get('GITHUB_REPOSITORY')}"
    run_number = os.environ.get("GITHUB_RUN_NUMBER")
    run_id = os.environ.get("GITHUB_RUN_ID")
    commit = os.environ.get("GITHUB_SHA")
    date = datetime.today().strftime("%Y-%m-%d %H:%M")

    new_lines = []
    for os_alias, stats in os_results.items():
        total_os = stats["success"] + stats["failure"]
        run_link = f"[#{run_number}]({url}/actions/runs/{run_id}) {os_alias}"
        log_line = f"| {run_link} | {date} | {stats['failure']}/{total_os} |"
        if stats["failures"]:
            unique_failures = sorted(list(set(stats["failures"])))
            for package in unique_failures:
                log_line += f" [{package}]({url}/blob/{commit}/packages/{package})"
        else:
            log_line += " :partying_face: "
        log_line += " |\n"
        new_lines.append(log_line)

    # Insert into wiki file
    HEADER_SIZE = 3
    MAX_ENTRIES = 200

    if not os.path.exists(log_file):
        # Create it if it doesn't exist (useful for testing)
        with open(log_file, "w") as f:
            f.write("# Daily Failures\n\n| Run | Date | Score | Details |\n|---|---|---|---|\n")

    with open(log_file) as f:
        lines = f.readlines()

    # Write new lines (one per OS found) at the top of the history
    with open(log_file, "w") as f:
        f.writelines(lines[:HEADER_SIZE] + new_lines + lines[HEADER_SIZE:MAX_ENTRIES])


if __name__ == "__main__":
    main()
