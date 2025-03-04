import argparse
import os
import pathlib
import xml.etree.ElementTree as ET
from collections import defaultdict

packagesByCategory = defaultdict(str)


def sort_write_wiki_content(file_path):
    """
    Retrieves rows pertaining to the key category, as a result of
    iterating over packagesByCategory.
    Writes to the Markdown formatted string:
    - header with the category name
    - table with two columns: Package and Description of each of the packages
    Args:
       file_path: path of the wiki file
    """
    wikiContent = ""
    for category in packagesByCategory.keys():
        wikiContent += "## " + category + "\n\n"
        wikiContent += "| Package | Description |\n"
        wikiContent += "|---|---|\n"
        wikiContent += packagesByCategory[category] + "\n\n"
    with open(file_path, "w", encoding="utf-8") as f:
        f.write(wikiContent)


def find_element_text(parent, tag_name):
    """Retrieves the text from a xml node, it validates if the tag exists
    Args:
       parent: parent tree to search
       tag_name: tag to search the text
    Returns:
       the tag text value
    """
    tag = parent.find(f"{{*}}{tag_name}")
    if tag is None:
        return None
    return tag.text


def process_packages_directory(packages_dir):
    """Parses all the nuspec files in the 'packages' directory structure.
    It saves into packagesByCategory[category] a line containing the package
    name and the description separated by |
    Args:
        packages: directory of packages
    """
    if not os.path.isdir(packages_dir):
        raise FileNotFoundError(f"Packages directory not found: {packages_dir}")

    for nuspec_path in pathlib.Path(packages_dir).glob("**/*.nuspec"):
        nuspec_tree = ET.parse(nuspec_path)
        nuspec_metadata = nuspec_tree.find("{*}metadata")
        if nuspec_metadata is not None:
            category = find_element_text(nuspec_metadata, "tags")
            # we are only interested in the packages with a category
            # some packages that assist with the istallation (such as common.vm) do
            # not contain a category
            if category is None:
                continue
            else:
                description = find_element_text(nuspec_metadata, "description")
                package = find_element_text(nuspec_metadata, "id")
                """packagesByCategory is a dictionary of str where each package and description
                are appended formatted in Markdown"""
                packagesByCategory[category] += "|" + package + "|" + description + "|\n"


if __name__ == "__main__":

    parser = argparse.ArgumentParser(description="Create wiki of packages.")
    parser.add_argument("--packages", type=str, required=False, default="packages", help="Path to packages")
    parser.add_argument("--wiki", type=str, required=False, default="wiki/Packages.md", help="Path to the wiki")
    args = parser.parse_args()
    process_packages_directory(args.packages)
    sort_write_wiki_content(args.wiki)
