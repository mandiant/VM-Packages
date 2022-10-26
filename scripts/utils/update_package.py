import hashlib
import re
import requests
import sys


def get_latest_version(org, project, version):
    response = requests.get(f"https://api.github.com/repos/{org}/{project}/releases/latest")
    if not response.ok:
        print(response)
        exit(1)
    latest_version = response.json()["tag_name"]
    if latest_version == version:
        print("it is up-to-date")
        exit(2)
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
        print("has wrong version")
        exit(3)
    return match.group("version")


def update(package):
    chocolateyinstall_path = f"packages/{package}/tools/chocolateyinstall.ps1"
    with open(chocolateyinstall_path, "r") as file:
        content = file.read()
        # Use findall as some packages have two urls (for 32 and 64 bits), we need to update both
        # Match urls like https://github.com/mandiant/capa/releases/download/v4.0.1/capa-v4.0.1-windows.zip
        matches = re.findall(
            "[\"'](?P<url>https://github.com/(?P<org>[^/]+)/(?P<project>[^/]+)/releases/download/(?P<version>[^/]+)/[^\"']+)[\"']",
            content,
        )

    if not matches:
        print("it is not a GitHub release")
        exit(4)

    latest_version = None
    for url, org, project, version in matches:
        latest_version_match = get_latest_version(org, project, version)
        # The version of the 32 and 64 bit downloads need to be the same, we only have one nuspec
        if latest_version and latest_version_match != latest_version:
            print("has several versions")
            exit(5)
        latest_version = latest_version_match
        latest_url = url.replace(version, latest_version)
        sha256 = get_sha256(url)
        latest_sha256 = get_sha256(latest_url)
        # Hash can be uppercase or downcase
        content = content.replace(sha256, latest_sha256).replace(sha256.upper(), latest_sha256)

    content = content.replace(version, latest_version)
    print(latest_version)
    with open(chocolateyinstall_path, "w") as file:
        file.write(content)

    nuspec_path = f"packages/{package}/{package}.nuspec"
    with open(nuspec_path, "r") as file:
        content = file.read()
    # Replace version in nuspec, for example `<version>1.6.3</version>`
    content = re.sub("<version>[^<]+</version>", f"<version>{format_version(latest_version)}</version>", content)
    with open(nuspec_path, "w") as file:
        file.write(content)


if __name__ == "__main__":
    update(sys.argv[1])
