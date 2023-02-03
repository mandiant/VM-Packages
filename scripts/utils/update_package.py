import hashlib
import os
import re
import requests
import sys
import time

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
        latest_version = format_version(latest_version)
    # If same version add date
    if version == latest_version:
        latest_version += "." + time.strftime("%Y%m%d")
    return latest_version, re.sub("<version>[^<]+</version>", f"<version>{latest_version}</version>", nuspec_content)


def get_latest_version(org, project, version):
    response = requests.get(f"https://api.github.com/repos/{org}/{project}/releases/latest")
    if not response.ok:
        return None
    latest_version = response.json()["tag_name"]
    return latest_version


def get_sha256(url):
    return hashlib.sha256(requests.get(url).content).hexdigest()


def format_version(version):
    # Get first three segments of version (which can be preceded by `v`)
    # For example:
    # v1.2.3 -> 1.2.3
    # 1.2.3-p353 -> 1.2.3
    # 1.2.3.4 -> 1.2.3
    # v1.2 -> 1.2
    # 1 -> 1
    match = re.match("v?(?P<version>\d+(.\d+){0,2})", version)
    if not match:
        raise ValueError("wrong version")
    return match.group("version")


def update_github_url(package):
    chocolateyinstall_path = f"packages/{package}/tools/chocolateyinstall.ps1"
    with open(chocolateyinstall_path, "r") as file:
        content = file.read()
        # Use findall as some packages have two urls (for 32 and 64 bits), we need to update both
        # Match urls like https://github.com/mandiant/capa/releases/download/v4.0.1/capa-v4.0.1-windows.zip
        matches = re.findall(
            "[\"'](?P<url>https://github.com/(?P<org>[^/]+)/(?P<project>[^/]+)/releases/download/(?P<version>[^/]+)/[^\"']+)[\"']",
            content,
        )

    # It is not a GitHub release
    if not matches:
        return None

    latest_version = None
    for url, org, project, version in matches:
        latest_version_match = get_latest_version(org, project, version)
        # No newer version available
        if (not latest_version) or (latest_version_match == version):
            return None
        # The version of the 32 and 64 bit downloads need to be the same, we only have one nuspec
        if latest_version and latest_version_match != latest_version:
            return None
        latest_version = latest_version_match
        latest_url = url.replace(version, latest_version)
        sha256 = get_sha256(url)
        latest_sha256 = get_sha256(latest_url)
        # Hash can be uppercase or downcase
        content = content.replace(sha256, latest_sha256).replace(sha256.upper(), latest_sha256)

    content = content.replace(version, latest_version)
    with open(chocolateyinstall_path, "w") as file:
        file.write(content)

    nuspec_path = f"packages/{package}/{package}.nuspec"
    with open(nuspec_path, "r") as file:
        content = file.read()
    latest_version, content = replace_version(latest_version, content)
    with open(nuspec_path, "w") as file:
        file.write(content)
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


if __name__ == "__main__":
    package_name = sys.argv[1]
    # Only update dependencies if no GitHub url was updated
    latest_version = update_github_url(package_name) or update_dependencies(package_name)
    # Package was not updated
    if not latest_version:
        exit(1)
    print(latest_version)
