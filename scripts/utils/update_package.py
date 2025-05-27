import argparse
import hashlib
import os
import re
import time
import xml.etree.ElementTree as ET
from enum import IntEnum
from pathlib import Path

import requests


# Replace version in nuspec, for example:
# `<version>1.6.3</version>`
# `<version>1.6.3.20220315</version>`
def replace_version(latest_version, nuspec_content):
    # Find current package version
    m = re.search("<version>(?P<version>[^<]+)</version>", nuspec_content)
    version = format_version(m.group("version"))
    if not latest_version:
        latest_version = version
    else:
        try:
            latest_version = format_version(latest_version)
        except ValueError:
            # not all tools use symver, observed examples: `cp_1.1.0` or `current`
            print(f"unusual version format: {latest_version}")
            print("reusing old version with updated date, manual fixing may be appropriate")
            latest_version = version
    # If same version add date
    if version == latest_version:
        latest_version += "." + time.strftime("%Y%m%d")
    return latest_version, re.sub("<version>[^<]+</version>", f"<version>{latest_version}</version>", nuspec_content)


# Get latest version from GitHub releases
def get_latest_version(org, project, version):
    response = requests.get(f"https://api.github.com/repos/{org}/{project}/releases/latest")
    if not response.ok:
        print(f"GitHub API response not ok: {response.status_code}")
        return None
    latest_version = response.json()["tag_name"]
    # Version parsing in update_github_url excludes 'v'. Consequently the latest_version must also exclude 'v' if present.
    # Otherwise, the github URL would would be replace by a version with double `v`, such as:
    # https://github.com/jstrosch/sclauncher/releases/download/vv0.0.6/sclauncher.exe
    if latest_version.startswith("v"):
        return latest_version[1:]
    else:
        return latest_version


# Get URL response's content SHA256 hash
def get_sha256(url):
    response = requests.get(url)
    if not response.ok:
        return None
    return hashlib.sha256(response.content).hexdigest()


# Get first three segments of version (which can be preceded by `v`)
# For example:
# v1.2.3 -> 1.2.3
# 1.2.3-p353 -> 1.2.3
# 1.2.3.4 -> 1.2.3
# v1.2 -> 1.2
# 1 -> 1
def format_version(version):
    match = re.match(r"v?(?P<version>\d+(.\d+){0,2})", version)
    if not match:
        raise ValueError(f"wrong version: {version}")
    return match.group("version")


# get content of nuspec file
def get_nuspec(package):
    nuspec_path = f"packages/{package}/{package}.nuspec"
    with open(nuspec_path, "r") as file:
        content = file.read()
    return (nuspec_path, content)


# get nuspec version
def get_version_from_nuspec(package):
    _, content = get_nuspec(package)

    # find the version from nuspec
    return re.findall(r"<version>(?P<version>[^<]+)</version>", content)[0]


# check if the package has a `chocolateyinstall.ps1` file, some packages do not have one
def check_install_script_present(package):
    install_script_path = f"packages/{package}/tools/chocolateyinstall.ps1"
    return Path(install_script_path).is_file()


# Replace version in the package's nuspec file
def update_nuspec_version(package, latest_version):
    nuspec_path, content = get_nuspec(package)
    latest_version, content = replace_version(latest_version, content)
    with open(nuspec_path, "w") as file:
        file.write(content)
    return latest_version


# read the chocolateyinstall.ps1 package file
def get_install_script(package):
    install_script_path = f"packages/{package}/tools/chocolateyinstall.ps1"
    with open(install_script_path, "r") as file:
        content = file.read()
    return (install_script_path, content)


# Update package using GitHub releases
def update_github_url(package):
    install_script_path, content = get_install_script(package)
    # Use findall as some packages have two URLs (for 32 and 64 bits), we need to update both
    # Match URLs like https://github.com/mandiant/capa/releases/download/v4.0.1/capa-v4.0.1-windows.zip
    matches = re.findall(
        "[\"'](?P<url>https://github.com/(?P<org>[^/]+)/(?P<project>[^/]+)/releases/download/v?(?P<version>[^/]+)/[^\"']+)[\"']",
        content,
    )
    # Match also URLs like https://github.com/joxeankoret/diaphora/archive/refs/tags/3.0.zip
    matches += re.findall(
        "[\"'](?P<url>https://github.com/(?P<org>[^/]+)/(?P<project>[^/]+)/archive/refs/tags/v?(?P<version>[^/]+).zip)[\"']",
        content,
    )

    # It is not a GitHub release
    if not matches:
        return None

    latest_version = None
    for url, org, project, version in matches:
        latest_version_match = get_latest_version(org, project, version)
        # No newer version available
        if (not latest_version_match) or (latest_version_match == version):
            return None
        # The version of the 32 and 64 bit downloads need to be the same, we only have one nuspec
        if latest_version and latest_version_match != latest_version:
            return None
        latest_version = latest_version_match
        latest_url = url.replace(version, latest_version)
        sha256 = get_sha256(url)
        latest_sha256 = get_sha256(latest_url)
        # Hash can be uppercase or downcase
        if not latest_sha256:
            return None
        content = content.replace(sha256, latest_sha256).replace(sha256.upper(), latest_sha256)

    content = content.replace(version, latest_version)
    with open(install_script_path, "w") as file:
        file.write(content)

    update_nuspec_version(package, latest_version)

    return latest_version


def get_increased_version(url, version):
    version_list_original = version.split(".")
    # Try all possible increased versions, for example for 12.0.1
    # ['12.0.1.1', '13', '13.0', '13.0.0', '13.0.0.0', '12.1', '12.1.0', '12.0.2']
    # New possible segment
    versions = [version + ".1"]
    for i in range(len(version_list_original)):
        version_list = version_list_original.copy()
        version_list[i] = str(int(version_list[i]) + 1)
        version_i = ".".join(version_list[: i + 1])
        versions.append(version_i)
        # Try max of 4 segments
        for j in range(i, 3 - i):
            version_i += ".0"
            versions.append(version_i)
    for latest_version in versions:
        latest_url = url.replace(version, latest_version)
        latest_sha256 = get_sha256(latest_url)
        if latest_sha256:
            return (latest_version, latest_sha256)
    return (None, None)


# Retrieves the latest version and SHA256 hash of a Microsoft MSIXBUNDLE from a given URL.
# It parses the AppInstaller file to extract the version and the URI of the main bundle.
# Returns a tuple containing the latest version (with '.' replaced by '-') and its SHA256 hash, or (None, None) on failure.
def get_msixbundle_version(url, version):
    if not url.endswith(".msixbundle"):
        return (None, None)

    pack_name = url.split("/")[-1].replace(".msixbundle", "")

    resp = requests.get(f"https://aka.ms/{pack_name}/download")
    if not resp.ok:
        return (None, None)

    namespace = "http://schemas.microsoft.com/appx/appinstaller/2018"
    namespaces = {"ai": namespace}
    app_installer_version = None
    msixbundle_uri = None
    try:
        xml = ET.fromstring(resp.content.decode("utf-8"))
        app_installer_version = xml.get("Version")
        main_bundle_element = xml.find("ai:MainBundle", namespaces)
        if main_bundle_element is not None:
            msixbundle_uri = main_bundle_element.get("Uri")
        else:
            return (None, None)

        latest_sha256 = get_sha256(msixbundle_uri)
        if latest_sha256:
            latest_version = app_installer_version.replace(".", "-")
            return (latest_version, latest_sha256)
    except Exception:
        # do not print and error, as the CI expects this script to only print the version
        pass

    return (None, None)


# Update package which uses a generic url that includes the version
def update_version_url(package):
    install_script_path, content = get_install_script(package)
    # Use findall as some packages have two URLs (for 32 and 64 bits), we need to update both
    # Match URLs like:
    # - https://download.sweetscape.com/010EditorWin32Installer12.0.1.exe
    matches = re.findall(r"[\"'](https{0,1}://.+?[A-Za-z\-_]((?:\d{1,4}\.){1,3}\d{1,4})[\w\.\-]+)[\"']", content)

    # It doesn't include a download URL with the version
    if not matches:
        return None

    latest_version = None
    for url, version in matches:
        latest_version_match, latest_sha256 = get_increased_version(url, version)
        # No newer version available
        if (not latest_version_match) or (latest_version_match == version):
            return None
        # The version of the 32 and 64 bit downloads need to be the same, we only have one nuspec
        if latest_version and latest_version_match != latest_version:
            return None
        latest_version = latest_version_match
        sha256 = get_sha256(url)
        # Hash can be uppercase or downcase
        content = content.replace(sha256, latest_sha256).replace(sha256.upper(), latest_sha256)

    content = content.replace(version, latest_version)
    with open(install_script_path, "w") as file:
        file.write(content)

    update_nuspec_version(package, latest_version)

    return latest_version


# Update dependencies
# Metapackages have only one dependency and same name (adding `.vm`) and version as the dependency
def update_dependencies(package):
    nuspec_path, content = get_nuspec(package)
    matches = re.findall(
        r'<dependency id=["\'](?P<dependency>[^"\']+)["\']\s+version=["\']\[(?P<version>[^"\']+)\]["\'] */>', content
    )

    updates = False
    package_version = None
    for dependency, version in matches:
        stream = os.popen(f"powershell.exe choco find -er {dependency}")
        output = stream.read()
        # ignore case to also find dependencies like GoogleChrome
        m = re.search(rf"^{dependency}\|(?P<version>.+)", output, re.M | re.I)
        if m:
            latest_version = m.group("version")
            if latest_version != version:
                content = re.sub(
                    rf'<dependency id="{dependency}" version=["\']\[{version}\]["\'] */>',
                    f'<dependency id="{dependency}" version="[{latest_version}]" />',
                    content,
                )
                updates = True
                # both should be all lowercase via the linter, but let's be sure here
                if dependency.lower() == package[:-3].lower():  # Metapackage
                    package_version = latest_version
    if updates:
        package_version, content = replace_version(package_version, content)
        with open(nuspec_path, "w") as file:
            file.write(content)
        return package_version
    return None

# Update metapackage dependencies
# Metapackages have only one dependency and same name (adding `.vm`) and version as the dependency
def update_metapackage_dependencies(package):
    nuspec_path, content = get_nuspec(package)
    matches = re.findall(
        r'<dependency id=["\'](?P<dependency>[^"\']+)["\']\s+version=["\'](?P<version>[^"\'\[\]]+)["\'] */>', content
    )

    updates = False
    for dependency, version in matches:
        stream = os.popen(f"powershell.exe choco find -er {dependency}")
        output = stream.read()
        # ignore case to also find dependencies like GoogleChrome
        m = re.search(rf"^{dependency}\|(?P<version>.+)", output, re.M | re.I)
        if m:
            latest_version = m.group("version")
            if latest_version != version:
                content = re.sub(
                    rf'<dependency id="{dependency}"\s+version=["\']{version}["\']\s*/>',
                    f'<dependency id="{dependency}" version="{latest_version}" />',
                    content,
                )
                updates = True
    if updates:
        with open(nuspec_path, "w") as file:
            file.write(content)
    

# Update package which uses a generic URL that has no version
def update_dynamic_url(package):
    version = get_version_from_nuspec(package)

    # We only fix the hash of tools whose URLs don't download a concrete version.
    # The version for these tools has the format "0.0.0.yyyymmdd".
    if re.fullmatch(r"0\.0\.0\.(\d{8})", version):
        install_script_path, content = get_install_script(package)

        # find the URLs and SHA256 hashes in the `chocolateyinstall.ps1`
        matches_url = re.findall(r"[\"'](https{0,1}://[^\"']+)[\"']", content)
        matches_hash = re.findall(r"[\"']([a-fA-F0-9]{64})[\"']", content)

        # if there is no matching URL or no matching hashes or the number of matching URL is not equal to number of matching hashes exit out
        # works for multiple URL and hashes if the order of URLs and hash match from top to bottom
        if not matches_url or not matches_hash or len(matches_url) != len(matches_hash):
            return None

        # find the new hash and check with existing hash and replace if different
        for url, sha256 in zip(matches_url, matches_hash):
            latest_sha256 = get_sha256(url)
            if latest_sha256.lower() == sha256.lower():
                return None

            content = content.replace(sha256, latest_sha256).replace(sha256.upper(), latest_sha256)

        # write back the changed chocolateyinstall.ps1
        with open(install_script_path, "w") as file:
            file.write(content)

        # since not versioned URL, the current version will be same as previous version
        latest_version = update_nuspec_version(package, version)
        return latest_version


# Update package that url ends with .msixbundle
def update_msixbundle_url(package):
    install_script_path, content = get_install_script(package)

    if not content:
        return None

    # Match urls like:
    # - https://windbg.download.prss.microsoft.com/dbazure/prod/1-2502-25002-0/windbg.msixbundle
    m = re.search(
        r"[\"'](?P<url>https{0,1}:\/\/.+?[A-Za-z\-_]+\/(?P<version>\d+\-\d+\-\d+\-\d+)\/[A-Za-z\-_]+\.msixbundle)[\"']",
        content,
    )
    if not m:
        return None

    version = m.group("version")

    sha256_m = re.search(r"[\"'](?P<sha256>[A-Fa-f0-9]{64})[\"']", content)
    if not sha256_m:
        return None

    latest_version, latest_sha256 = get_msixbundle_version(m.group("url"), version)
    # No newer version available
    if (not latest_version) or (latest_version == version):
        return None

    sha256 = sha256_m.group("sha256")
    # Hash can be uppercase or downcase
    content = (
        content.replace(sha256, latest_sha256).replace(sha256.upper(), latest_sha256).replace(version, latest_version)
    )

    with open(install_script_path, "w") as file:
        file.write(content)

    update_nuspec_version(package, latest_version.replace("-", "."))

    return latest_version


class UpdateType(IntEnum):
    # UpdateTypes are defined using powers of 2 to allow for bitwise combinations.
    DEPENDENCIES = 1
    GITHUB_URL = 2
    VERSION_URL = 4
    DYNAMIC_URL = 8
    MSIXBUNDLE_URL = 16
    ALL = DEPENDENCIES | GITHUB_URL | VERSION_URL | DYNAMIC_URL | MSIXBUNDLE_URL

    def __str__(self):
        return self.name

    @staticmethod
    def from_str(string):
        try:
            return UpdateType[string]
        except KeyError:
            # ALL is the default value
            print("Invalid update type, default to ALL")
            return UpdateType.ALL


if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("package_name")
    parser.add_argument(
        "--update_type",
        type=UpdateType.from_str,
        choices=list(UpdateType),
        default=UpdateType.ALL,
    )
    args = parser.parse_args()

    is_install_script_present = check_install_script_present(args.package_name)

    latest_version = None

    # Update dependencies first, as it is required for other updates
    update_metapackage_dependencies(args.package_name)
    
    if args.update_type & UpdateType.DEPENDENCIES:
        latest_version = update_dependencies(args.package_name)

    if is_install_script_present:

        if args.update_type & UpdateType.GITHUB_URL:
            latest_version2 = update_github_url(args.package_name)
            if latest_version2:
                latest_version = latest_version2

        if args.update_type & UpdateType.VERSION_URL:
            latest_version2 = update_version_url(args.package_name)
            if latest_version2:
                latest_version = latest_version2

        if args.update_type & UpdateType.DYNAMIC_URL:
            latest_version = update_dynamic_url(args.package_name)

        if args.update_type & UpdateType.MSIXBUNDLE_URL:
            latest_version2 = update_msixbundle_url(args.package_name)
            if latest_version2:
                latest_version = latest_version2

    if not latest_version:
        exit(1)
    print(latest_version)
