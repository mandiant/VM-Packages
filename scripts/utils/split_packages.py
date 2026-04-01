import json
import os
import sys


def split_list(lst, n):
    """Split a list into n roughly equal chunks."""
    k, m = divmod(len(lst), n)
    indices = [(i * k + min(i, m), (i + 1) * k + min(i + 1, m)) for i in range(n)]
    return [lst[start:end] for start, end in indices]


def main():
    repo_root = os.path.abspath(os.path.join(os.path.dirname(__file__), "../.."))
    packages_dir = os.path.join(repo_root, "packages")

    if not os.path.exists(packages_dir):
        print(f"Error: packages directory not found at {packages_dir}", file=sys.stderr)
        sys.exit(1)

    packages = [
        d for d in os.listdir(packages_dir) if os.path.isdir(os.path.join(packages_dir, d)) and d.endswith(".vm")
    ]
    packages.sort()

    # We want 4 chunks
    chunks = split_list(packages, 4)

    # Convert each chunk to a space-separated string for the powershell script
    chunk_strings = [" ".join(chunk) for chunk in chunks]

    # Output JSON for GitHub Actions matrix
    print(json.dumps(chunk_strings))


if __name__ == "__main__":
    main()
