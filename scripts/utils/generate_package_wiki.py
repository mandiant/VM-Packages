import argparse
import pathlib
import xml.etree.ElementTree as ET
from collections import defaultdict
from urllib.request import urlopen

# Dict[str (category), Dict[str (pkg_name, (pkg_description, project_url))]]
packages_by_category = defaultdict(dict)

DEFAULT_CONFIG_URL = "https://raw.githubusercontent.com/mandiant/flare-vm/main/config.xml"
PACKAGE_URL_BASE = "https://github.com/mandiant/VM-Packages/tree/main/packages"


def sort_write_wiki_content(file_path, default_packages):
    """Writes package information sorted by category to a Markdown wiki file.

    This function iterates through the `packages_by_category` dictionary, which
    contains package information organized by category. For each category, it
    generates a Markdown header and a table containing package names (with a
    link to the package source code) and descriptions (including the project
    URL). Both the categories and the packages inside a category are sorted
    alphabetically. The packages in the DEFAULT_CONFIG_URL are marked in bold.
    The resulting Markdown content is then written to the specified file.

    Args:
        file_path: The path to the output Markdown file.
        default_packages: A set with the package names in the default config
    """
    wiki_content = f"""This page documents the available VM packages sorted by category.
The packages in the [FLARE-VM default configuration]({DEFAULT_CONFIG_URL}) are marked in bold.
This page is [generated automatically](https://github.com/mandiant/VM-Packages/blob/main/.github/workflows/generate_package_wiki.yml).
Do not edit it manually.\n
"""
    for category, packages in sorted(packages_by_category.items()):
        wiki_content += f"## {category}\n\n"
        wiki_content += "| Package | Description |\n"
        wiki_content += "| ------- | ----------- |\n"

        for pkg_name, pkg_info in sorted(packages.items()):
            description, project_url = pkg_info

            package_url = f"{PACKAGE_URL_BASE}/{pkg_name}"

            # Bold package name if the package is the default configuration
            if pkg_name in default_packages:
                pkg_name = f"**{pkg_name}**"

            # Append a link to the project's URL to the description
            if project_url:
                description = f"{description} [Link]({project_url})"

            wiki_content += f"| [{pkg_name}]({package_url}) | {description} |\n"

        wiki_content += "\n\n"
    with open(file_path, "w", encoding="utf-8") as f:
        f.write(wiki_content)


def find_element_text(parent, tag_name):
    """Retrieves the text content of a specified XML element.

    This function searches for a child element with the given tag name within the
    provided parent element. It handles XML namespaces by using a wildcard.

    Args:
        parent: The parent XML element.
        tag_name: The name of the child element to find.

    Returns:
        The text content of the found element, or None if the element is not found.
    """
    tag = parent.find(f"{{*}}{tag_name}")
    if tag is None:
        return None
    return tag.text


def get_default_packages():
    """Fetches and parses the packages in the default config

    This function retrieves the config.xml file, parses it, and extracts all
    package names, returning them as a set of strings.

    Returns:
        A set of strings.
    """
    with urlopen(DEFAULT_CONFIG_URL) as f:
        config_tree = ET.parse(f)

    packages_element = config_tree.getroot().find("packages")
    package_elements = packages_element.findall("package")
    return {pkg.get("name") for pkg in package_elements}


def process_packages_directory(packages_dir):
    """Obtains the package name, description and category from a directory

    This function parses all the nuspec files in the specified packages directory.
    It saves into packages_by_category[category] a dictionary with the package
    name as key and the description as value.

    Args:
        packages: directory where the packages reside.
    """
    if not pathlib.Path(packages_dir).is_dir():
        raise FileNotFoundError(f"Packages directory not found: {packages_dir}")

    for nuspec_path in pathlib.Path(packages_dir).glob("**/*.nuspec"):
        nuspec_tree = ET.parse(nuspec_path)
        nuspec_metadata = nuspec_tree.find("{*}metadata")
        if nuspec_metadata is not None:
            category = find_element_text(nuspec_metadata, "tags")
            # We are only interested in the packages with a category.
            # Some packages that assist with the istallation (such as common.vm) do
            # not contain a category
            if not category:
                continue
            package = find_element_text(nuspec_metadata, "id")
            description = find_element_text(nuspec_metadata, "description")
            project_url = find_element_text(nuspec_metadata, "projectUrl")
            packages_by_category[category][package] = (description, project_url)


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Create wiki of packages.")
    parser.add_argument("--packages", type=str, required=False, default="packages", help="Path to packages")
    parser.add_argument("--wiki", type=str, required=False, default="wiki/Packages.md", help="Path to the wiki")
    args = parser.parse_args()

    default_packages = get_default_packages()
    process_packages_directory(args.packages)
    sort_write_wiki_content(args.wiki, default_packages)
