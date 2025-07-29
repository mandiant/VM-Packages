# Copyright 2022 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

"""
Check the given packages for style issues.

Usage:

   $ python lint.py packages/
"""

import argparse
import datetime
import logging
import os
import pathlib
import re
import subprocess
import sys
from typing import Dict
from xml.dom import minidom

from packaging.version import Version

GIT_EXE = "git"

# set log level for debugging here script-wide
LOG_LEVEL = logging.INFO
logging.basicConfig(level=LOG_LEVEL)
logger = logging.getLogger("lint")


class Lint:
    WARN = "WARN"
    FAIL = "FAIL"

    name = "lint"
    level = FAIL
    recommendation = ""

    def check(self, path):
        """
        :return: True if lint failed
        """
        return False


def run_lints(lints, path):
    for lint_ in lints:
        if lint_.check(path):
            yield lint_


class FileNameNotAllLower(Lint):
    name = "file name not all lower case"
    recommendation = "Rename package path using all lower case letters"

    def check(self, path):
        return not path.name.islower()


PATH_LINTS = (FileNameNotAllLower(),)


def lint_path(path):
    return run_lints(PATH_LINTS, path)


def run_cmd(cmd):
    logger.debug("cmd: %s", cmd)
    p = subprocess.Popen(cmd.split(" "), stdout=subprocess.PIPE, stderr=subprocess.PIPE)
    out, err = p.communicate()
    out = out.decode("utf-8").strip()
    err = err.decode("utf-8").strip()
    logger.debug("cmd out: %s", out)
    logger.debug("cmd err: %s", err)
    return out


class InvalidDescriptionLength(Lint):
    max_length = 175
    name = "the description length is invalid"
    recommendation = f"the description must be limited to {max_length} characters maximum."

    def check(self, path):
        dom = minidom.parse(str(path))
        description = dom.getElementsByTagName("description")[0].firstChild.data
        if len(description) > self.max_length:
            print(f"The description has invalid length: {len(description)}")
            return True
        return False


class IncludesRequiredFieldsOnly(Lint):
    name = "file lists non-required fields"
    allowed_fields = [
        "id",
        "version",
        "description",
        "authors",
        "dependencies",
        "tags",
        "projectUrl",
    ]
    recommendation = f"Only include required fields: {', '.join(allowed_fields)}"

    def check(self, path):
        dom = minidom.parse(str(path))
        metadata = dom.getElementsByTagName("metadata")[0]

        non_required_fields = list()
        for c in metadata.childNodes:
            # Skip text nodes (whitespace) and comments.
            if c.nodeName == "#text" or c.nodeName == "#comment":
                continue
            if c.nodeName not in self.allowed_fields:
                non_required_fields.append(c.nodeName)
        return len(non_required_fields) != 0


class VersionFormatIncorrect(Lint):
    name = "the version value is invalid"
    recommendation = "see the VM-Packages Wiki for conventions and package structure related to the version string"

    def check(self, path):
        dom = minidom.parse(str(path))
        metadata = dom.getElementsByTagName("metadata")[0]

        version = metadata.getElementsByTagName("version")[0]
        version = version.firstChild.data.split(".")
        if len(version) > 4:
            print(f"{path} more than four version segments: {version}")
            return True

        for seg in version:
            try:
                int(seg)
            except ValueError:
                print(f"version part '{seg}' is not a number")
                return True

        if len(version) == 4:
            try:
                datetime.datetime.strptime(version[3], "%Y%m%d")
            except ValueError:
                print(f"{path} fourth version segment not in format %Y%m%d")
                return True

        # for metapackage that just installs/configures a specific tool (with locked dependency version)
        deps = dom.getElementsByTagName("dependency")
        # common.vm and one locked dependency
        if len(deps) <= 2:
            pkg_id = metadata.getElementsByTagName("id")[0].firstChild.data.replace("vm", "")
            for d in deps:
                if d.getAttribute("id") != pkg_id:
                    continue

                if d.getAttribute("version"):
                    dep_version = d.getAttribute("version")
                    if dep_version.startswith("[") and dep_version.endswith("]"):
                        dep_version = dep_version[1:-1].split(".")
                        if len(dep_version) == 4:
                            if dep_version[:3] != version[:3]:
                                print(f"{path} package version should start with {'.'.join(dep_version[:3])}")
                                return True
                            if len(version) != 4:
                                print(f"{path} package version should use current date (YYYYMMDD) in the 4th segment")
                                return True
                        elif dep_version != version:
                            # when change is made to a metapackage, use the current date in the 4th segment
                            if len(version) == 4 and dep_version[:3] == version[:3]:
                                return False
                            print(f"{path} package version should be {'.'.join(dep_version)}")
                            return True

        return False


class VersionNotIncreased(Lint):
    name = "the version has not been increased"
    recommendation = "the version in the nuspec file must be higher than the one in MyGet"

    source = "https://www.myget.org/F/vm-packages/api/v2"

    def __get_remote_version(self, package_name):
        stream = os.popen(f"powershell.exe choco find -er {package_name} -s {self.source}")
        output = stream.read()
        m = re.search(rf"^{package_name}\|(?P<version>.+)", output, re.M)
        if not m:
            return None
        return m.group("version")

    def check(self, path):
        dom = minidom.parse(str(path))
        metadata = dom.getElementsByTagName("metadata")[0]
        local_version = metadata.getElementsByTagName("version")[0].firstChild.data

        package_id = metadata.getElementsByTagName("id")[0].firstChild.data
        remote_version = self.__get_remote_version(package_id)
        # Package not found in MyGet, the local version is the first version of the package
        if not remote_version:
            print("Package not found in MyGet")
            return False

        if Version(local_version) < Version(remote_version):
            print(f"{path} package version ({local_version}) must be higher than the one in MyGet ({remote_version})")
            return True
        return False


class DoesNotListDependencyCommonVm(Lint):
    name = "does not depend on common.vm"
    recommendation = "add the common.vm dependency"

    def check(self, path):
        if "common.vm" in str(path):
            return False

        dom = minidom.parse(str(path))
        deps = dom.getElementsByTagName("dependency")
        if len(deps) == 0:
            return True

        for d in deps:
            if d.getAttribute("id") == "common.vm":
                return False
        return True


class DependencyContainsUppercaseChar(Lint):
    name = "dependency contains an uppercase character"
    recommendation = "change dependency to all lowercase characters"

    def check(self, path):
        dom = minidom.parse(str(path))
        deps = dom.getElementsByTagName("dependency")
        for d in deps:
            if any(c.isupper() for c in d.getAttribute("id")):
                return True
        return False


class PackageIdNotMatchingFolderOrNuspecName(Lint):
    name = "package ID doesn't match package folder name or nuspec file name"
    recommendation = "make sure the package ID is the same as the package folder name and the nuspec file name"

    def check(self, path):
        dom = minidom.parse(str(path))
        pkg_id = dom.getElementsByTagName("id")[0].firstChild.data

        nuspec = path.parts[-1]
        folder = path.parts[-2]

        return not (pkg_id == folder == nuspec[: -len(".nuspec")])


class UsesInvalidCategory(Lint):
    # The common.vm, debloat.vm, and installer.vm packages are special as they
    # assist with the installation and allow to share code between packages.
    # They do not install any tool and consequently don't have a category.
    EXCLUSIONS = [
        "common.vm",
        "debloat.vm",
        "installer.vm",
    ]
    root_path = os.path.abspath(os.path.join(__file__, "../../.."))
    categories_txt = os.path.join(root_path, "categories.txt")
    with open(categories_txt) as file:
        CATEGORIES = [line.rstrip() for line in file]
        logger.debug(CATEGORIES)

    name = "uses an invalid category"
    recommendation = f"use a category from {categories_txt} between <tags> and </tags>"

    def check(self, path):
        if any([exclusion in str(path) for exclusion in self.EXCLUSIONS]):
            return False

        # utf-8-sig ignores BOM
        file_content = open(path, "r", encoding="utf-8-sig").read()

        match = re.search(r"<tags>(?P<category>[\w ]+)<\/tags>", file_content)
        if not match or match.group("category") not in self.CATEGORIES:
            return True
        return False


NUSPEC_LINTS = (
    IncludesRequiredFieldsOnly(),
    VersionFormatIncorrect(),
    VersionNotIncreased(),
    DoesNotListDependencyCommonVm(),
    DependencyContainsUppercaseChar(),
    PackageIdNotMatchingFolderOrNuspecName(),
    UsesInvalidCategory(),
    InvalidDescriptionLength(),
)


def lint_nuspec(path):
    return run_lints(NUSPEC_LINTS, path)


class MissesImportCommonVm(Lint):
    IMPORT_LINE = "Import-Module vm.common -Force -DisableNameChecking"
    name = "does not import common.vm"
    recommendation = f"add `{IMPORT_LINE}` to script"

    def check(self, path):
        if "common.vm" in str(path):
            return False

        # utf-8-sig ignores BOM
        with open(path, "r", encoding="utf-8-sig") as f:
            lines = f.read().splitlines()

        return not any([self.IMPORT_LINE == line for line in lines])


class FirstLineDoesNotSetErrorAction(Lint):
    EXCLUSIONS = ["libraries.python2.vm", "libraries.python3.vm", "installer.vm"]
    FIRST_LINE = "$ErrorActionPreference = 'Stop'"
    name = "first line must set error handling to stop"
    recommendation = f"add `{FIRST_LINE}` to the file"

    def check(self, path):
        if any([exclusion in str(path) for exclusion in self.EXCLUSIONS]):
            return False

        # utf-8-sig ignores BOM
        with open(path, "r", encoding="utf-8-sig") as f:
            lines = f.read().splitlines()

        return not self.FIRST_LINE == lines[0]


class UsesCategoryFromNuspec(Lint):
    # Some packages don't have a category (we don't create a link in the tools directory)
    EXCLUSIONS = [
        ".dbgchild.vm",
        ".ollydumpex.vm",
        ".scyllahide.vm",
        "common.vm",
        "debloat.vm",
        "dokan.vm",
        "googlechrome.vm",
        "ida.plugin",
        "installer.vm",
        "libraries.python2.vm",
        "libraries.python3.vm",
        "notepadpp.plugin.",
        "npcap.vm",
        "openjdk.vm",
        "pdbs.pdbresym.vm",
        "python3.vm",
        "x64dbgpy.vm",
        "vscode.extension.",
        "chrome.extensions.vm",
        "keystone.vm",
    ]

    name = "Doesn't use the function VM-Get-Category"
    recommendation = "Set '$category = VM-Get-Category($MyInvocation.MyCommand.Definition)'"

    def check(self, path):
        if any([exclusion in str(path) for exclusion in self.EXCLUSIONS]):
            return False

        # utf-8-sig ignores BOM
        file_content = open(path, "r", encoding="utf-8-sig").read()

        pattern = re.escape("$category = VM-Get-Category($MyInvocation.MyCommand.Definition)")
        match = re.search(pattern, file_content)
        if not match:
            return True
        return False


INSTALL_LINTS = (
    MissesImportCommonVm(),
    FirstLineDoesNotSetErrorAction(),
    UsesCategoryFromNuspec(),
)

UNINSTALL_LINTS = (UsesCategoryFromNuspec(),)


def lint_install(path):
    return run_lints(INSTALL_LINTS, path)


def lint_uninstall(path):
    return run_lints(UNINSTALL_LINTS, path)


def lint(path) -> Dict[str, list]:
    ret = {}
    for root, dirs, files in os.walk(path):

        # lint path name of empty directories
        ret[root] = lint_path(pathlib.Path(root))

        for name in files:
            if name.endswith(".md"):
                continue

            violations = list()

            path = pathlib.Path(os.path.join(root, name))
            logger.info("linting %s", path)

            violations.extend(list(lint_path(path)))

            if ".nuspec" in name:
                violations.extend(lint_nuspec(path))
            elif "chocolateyinstall.ps1" in name:
                violations.extend(lint_install(path))
            elif "chocolateyuninstall.ps1" in name:
                violations.extend(lint_uninstall(path))

            ret[str(path)] = violations

    return ret


def main(argv=None):
    if argv is None:
        argv = sys.argv[1:]

    parser = argparse.ArgumentParser(description="Lint packages.")
    parser.add_argument("packages", type=str, help="Path to packages")
    args = parser.parse_args(args=argv)

    results_by_name = lint(args.packages)

    fails = 0
    for name, violations in results_by_name.items():
        for violation in violations:
            print(
                "%s: %s - %s: %s"
                % (
                    violation.level,
                    name,
                    violation.name,
                    violation.recommendation,
                )
            )

            if violation.level == Lint.FAIL:
                fails += 1

    if fails:
        print(f"{fails} lints failed :(")
        return 1
    else:
        print("no lints failed, nice!")
        return 0


if __name__ == "__main__":
    sys.exit(main())
