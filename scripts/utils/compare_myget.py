import glob
import os
import re
import subprocess

log_file = "wiki/MyGet-Version-Mismatches.md"
source = "https://www.myget.org/F/vm-packages/api/v2"


# Convert 1.02.0 to 1.2 to ensure we compare versions consistency
def format_version(version):
    version = re.sub(r"\.0(?P<digit>\d)", lambda x: f".{x.group('digit')}", version)
    return re.sub(r"(\.0+)+$", "", version)


def get_remote_version(package_name):
    stream = os.popen(f"choco find -er {package_name} -s {source}")
    output = stream.read()
    m = re.search(rf"^{package_name}\|(?P<version>.+)", output, re.M)
    if not m:
        return ""
    return m.group("version")


def sync_package(package_name, local_version):
    os.makedirs("built_pkgs", exist_ok=True)
    proc = subprocess.run(f"choco pack packages\\{package_name}\\{package_name}.nuspec -y -out built_pkgs", shell=True)
    if proc.returncode != 0:
        return False

    pkg_nupkg = f"built_pkgs\\{package_name}.{local_version}.nupkg"
    proc = subprocess.run(f"choco push {pkg_nupkg} -s {source} -k {os.environ.get('MYGET_TOKEN')}", shell=True)
    if proc.returncode != 0:
        return False

    return True


mismatches = []
nuspecs_path = "packages/*/*.nuspec"
nuspecs = glob.glob(nuspecs_path)
for nuspec in nuspecs:
    with open(nuspec, "r") as file:
        nuspec_content = file.read()

    # Find local package version
    m = re.search("<id>(?P<name>[^<]+)</id>", nuspec_content)
    m2 = re.search("<version>(?P<version>[^<]+)</version>", nuspec_content)

    if m and m2:
        name = m.group("name")
        local_version = m2.group("version")
        my_get_version = get_remote_version(name)
        if format_version(local_version) != format_version(my_get_version):
            if not sync_package(name, local_version):
                mismatches.append([name, my_get_version, local_version])

log_f = open(log_file, "w")
if not mismatches:
    log_f.write("**All local versions match MyGet versions** :tada:")
else:
    W1 = 40
    W2 = 25
    log_f.write("The following packages local version do not match the latest version in MyGet.\n\n")
    log_f.write(
        f"| {'Package Name'.ljust(W1)} | {'MyGet version'.ljust(W2)} | {'Local version'.ljust(W2)} |\n|-|-|-|\n"
    )
    for mismatch in mismatches:
        log_f.write(f"| {mismatch[0].ljust(W1)} | {mismatch[1].rjust(W2)} | {mismatch[2].rjust(W2)} |\n")

print(len(mismatches))
