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

    total_success = 0
    total_failed = 0
    all_failures = []

    # Track which chunks we processed for the wiki log
    processed_files = []

    for dirpath, _, filenames in os.walk(artifacts_dir):
        for filename in filenames:
            if filename == "success_failure.json":
                filepath = os.path.join(dirpath, filename)
                try:
                    with open(filepath) as f:
                        data = json.load(f)
                        total_success += data.get("success", 0)
                        total_failed += data.get("failure", 0)
                        all_failures.extend(data.get("failures", []))
                        processed_files.append(filename)
                except Exception as e:
                    print(f"Warn: Failed to read {filename} in {dirpath}: {e}", file=sys.stderr)

    total_packages = total_success + total_failed

    # Write combined JSON for the badge step
    final_result = {
        "success": total_success,
        "failure": total_failed,
        "total": total_packages,
        "failures": all_failures,
    }
    with open(result_file, "w") as f:
        json.dump(final_result, f, indent=4)

    # Write combine entry to Wiki
    if not os.path.exists("wiki"):
        print("Error: Wiki directory not found", file=sys.stderr)
        sys.exit(1)

    url = f"https://github.com/{os.environ.get('GITHUB_REPOSITORY')}"
    run_number = os.environ.get("GITHUB_RUN_NUMBER")
    run_id = os.environ.get("GITHUB_RUN_ID")
    commit = os.environ.get("GITHUB_SHA")

    run_link = f"[#{run_number}]({url}/actions/runs/{run_id}) Win22"
    date = datetime.today().strftime("%Y-%m-%d %H:%M")

    log_line = f"| {run_link} | {date} | {total_failed}/{total_packages} |"
    if all_failures:
        for package in all_failures:
            log_line += f" [{package}]({url}/blob/{commit}/packages/{package})"
    else:
        log_line += " :partying_face: "
    log_line += " |\n"

    # Insert into wiki file
    HEADER_SIZE = 3
    MAX_ENTRIES = 200

    if not os.path.exists(log_file):
        # Create it if it doesn't exist (useful for testing)
        with open(log_file, "w") as f:
            f.write("# Daily Failures\n\n| Run | Date | Score | Details |\n|---|---|---|---|\n")

    with open(log_file) as f:
        lines = f.readlines()

    with open(log_file, "w") as f:
        f.writelines(lines[:HEADER_SIZE] + [log_line] + lines[HEADER_SIZE:MAX_ENTRIES])


if __name__ == "__main__":
    main()
