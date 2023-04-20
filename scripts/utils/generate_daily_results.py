import json
import sys
from datetime import datetime

# _, github.repository, github.sha, github.run_number, github.run_id, github.job, os
_, repository, commit, run_number, run_id, os = sys.argv

# Do not keep old failures as logs are only kept for 90 days
result_file = "success_failure.json"
log_file = "wiki/Daily-Failures.md"

with open(result_file) as result_f:
    result = json.load(result_f)

url = f"https://github.com/{repository}"
# Short OS (windows-2019 -> Win19) for nicer table display
run = f"[#{run_number}]({url}/actions/runs/{run_id}) Win{os[-2:]}"
date = datetime.today().strftime("%Y-%m-%d %H:%M")
log_line = f"\n| {run} | {date} | {result['failure']}/{result['total']} |"
for package in result["failures"]:
    log_line += f" [{package}]({url}/blob/{commit}/packages/{package})"
log_line += " |"

with open(log_file, "a") as log_f:
    log_f.write(log_line)
