import hashlib
import os
import re
import requests
import sys
import time
import argparse
from enum import IntEnum

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
    return latest_version


# Get url response's content hash (SHA256)
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
    match = re.match("v?(?P<version>\d+(.\d+){0,2})", version)
    if not match:
        raise ValueError(f"wrong version: {version}")
    return match.group("version")


# Replace version in the package's nuspec file
def update_nuspec_version(package, latest_version):
    nuspec_path = f"packages/{package}/{package}.nuspec"
    with open(nuspec_path, "r") as file:
        content = file.read()
    latest_version, content = replace_version(latest_version, content)
    with open(nuspec_path, "w") as file:
        file.write(content)


# read the chocolateyinstall.ps1 package file
def get_install_script(package):
    install_script_path = f"packages/{package}/tools/chocolateyinstall.ps1"
    try:
        file = open(install_script_path, "r")
    except FileNotFoundError:
        # chocolateyinstall.ps1 may not exist for metapackages
        return (None, None)
    return (install_script_path, file.read())


# Update package using GitHub releases
def update_github_url(package):
    install_script_path, content = get_install_script(package)
    # Use findall as some packages have two urls (for 32 and 64 bits), we need to update both
    # Match urls like https://github.com/mandiant/capa/releases/download/v4.0.1/capa-v4.0.1-windows.zip
    matches = re.findall(
        "[\"'](?P<url>https://github.com/(?P<org>[^/]+)/(?P<project>[^/]+)/releases/download/v?(?P<version>[^/]+)/[^\"']+)[\"']",
        content,
    )
    # Match also urls like https://github.com/joxeankoret/diaphora/archive/refs/tags/3.0.zip
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
    versions = [ version + ".1"]
    for i in range(len(version_list_original)):
        version_list = version_list_original.copy()
        version_list[i] = str(int(version_list[i]) + 1)
        version_i = ".".join(version_list[:i+1])
        versions.append(version_i)
        # Try max of 4 segments
        for j in range(i, 3-i):
            version_i += ".0"
            versions.append(version_i)
    for latest_version in versions:
        latest_url = url.replace(version, latest_version)
        latest_sha256 = get_sha256(latest_url)
        if latest_sha256:
            return (latest_version, latest_sha256)
    return (None, None)


# Update package which uses a generic url that includes the version
def update_version_url(package):
    install_script_path, content = get_install_script(package)
    # Use findall as some packages have two urls (for 32 and 64 bits), we need to update both
    # Match urls like:
    # - https://download.sweetscape.com/010EditorWin32Installer12.0.1.exe
    # - https://www.winitor.com/tools/pestudio/current/pestudio-9.53.zip
    matches = re.findall("[\"'](https{0,1}://.+?[A-Za-z\-_]((?:\d{1,4}\.){1,3}\d{1,4})[\w\.\-]+)[\"']", content)

    # It doesn't include a download url with the version
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
        latest_url = url.replace(version, latest_version)
        sha256 = get_sha256(url)
        # Hash can be uppercase or downcase
        content = content.replace(sha256, latest_sha256).replace(sha256.upper(), latest_sha256)

    content = content.replace(version, latest_version)
    with open(install_script_path, "w") as file:
        file.write(content)

    update_nuspec_version(package, latest_version)

    return latest_version


# Update dependencies
# Metapackages have only one dependency and same name (adding `.vm`)  and version as the dependency
def update_dependencies(package):
    nuspec_path = f"packages/{package}/{package}.nuspec"
    with open(nuspec_path, "r", encoding="utf-8") as file:
        content = file.read()
    matches = re.findall(
        f'<dependency id=["\'](?P<dependency>[^"\']+)["\'] version="\[(?P<version>[^"\']+)\]" */>',
        content,
    )

    updates = False
    package_version = None
    for dependency, version in matches:
        stream = os.popen(f"powershell.exe choco find -er {dependency}")
        output = stream.read()
        # ignore case to also find dependencies like GoogleChrome
        m = re.search(f"^{dependency}\|(?P<version>.+)", output, re.M | re.I)
        if m:
            latest_version = m.group("version")
            if latest_version != version:
                content = re.sub(
                    f'<dependency id="{dependency}" version=["\']\[{version}\]["\'] */>',
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


class UpdateType(IntEnum):
    DEPENDENCIES = 1
    GITHUB_URL = 2
    VERSION_URL = 4
    ALL = DEPENDENCIES | GITHUB_URL | VERSION_URL

    def __str__(self):
        return self.name

    @staticmethod
    def from_str(string):
        try:
            return UpdateType[string]
        except:
            # ALL is the default value
            print("Invalid update type, default to ALL")
            return UpdateType.ALL


if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("package_name")
    parser.add_argument("--update_type", type=UpdateType.from_str, choices=list(UpdateType), default=UpdateType.ALL)
    args = parser.parse_args()

    latest_version = None
    if args.update_type & UpdateType.DEPENDENCIES:
        latest_version = update_dependencies(args.package_name)

    if args.update_type & UpdateType.GITHUB_URL:
        latest_version2 = update_github_url(args.package_name)
        if latest_version2:
            latest_version = latest_version2

    if args.update_type & UpdateType.VERSION_URL:
        latest_version2 = update_version_url(args.package_name)
        if latest_version2:
            latest_version = latest_version2

    if not latest_version:
        exit(1)
    print(latest_version)
