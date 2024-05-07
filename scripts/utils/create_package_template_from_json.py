#!/usr/bin/env python
import json
import argparse

import create_package_template


def main():
    parser = argparse.ArgumentParser(
        description="Wrapper for 'create_package_template.py' that receives the arguments from JSON data and prints the package name."
    )
    parser.add_argument("--json_str", type=str, help="JSON string")
    parser.add_argument("--json_file", type=str, help="JSON file path")
    args = parser.parse_args()

    if args.json_str:
        pkg = json.loads(args.json_str)
    elif args.json_file:
        with open(args.json_file, "r", encoding="utf-8") as f:
            pkg = json.load(f)
    else:
        raise parser.error("missing --json_str or --json_file argument")

    cmd_args = list()
    for k, v in pkg.items():
        if k in ("why", "dependencies", "info"):
            continue
        cmd_args.append(f"--{k}")
        cmd_args.append(f"{v}")

    create_package_template.main(cmd_args)

    # Print the package name so that we can use it from workflows/new_package.yml
    print(pkg["pkg_name"])


if __name__ == "__main__":
    main()
