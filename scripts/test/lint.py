"""
Check the given packages for style issues.

Usage:

   $ python lint.py packages/

Copyright (C) 2022 Mandiant, Inc. All Rights Reserved.
Licensed under the Apache License, Version 2.0 (the "License");
 you may not use this file except in compliance with the License.
You may obtain a copy of the License at: [package root]/LICENSE.txt
Unless required by applicable law or agreed to in writing, software distributed under the License
 is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and limitations under the License.
"""
import os
import sys
import logging
import pathlib
import argparse
import datetime
from typing import Dict
from xml.dom import minidom

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


class IncludesRequiredFieldsOnly(Lint):
    name = "file lists non-required fields"
    allowed_fields = [
        "id",
        "version",
        "description",
        "authors",
        "dependencies",
    ]
    recommendation = f"Only include required fields: {', '.join(allowed_fields)}"

    def check(self, path):
        dom = minidom.parse(str(path))
        metadata = dom.getElementsByTagName("metadata")[0]

        non_required_fields = list()
        for c in metadata.childNodes:
            if c.nodeName == "#text":
                continue
            if c.nodeName not in self.allowed_fields:
                non_required_fields.append(c.nodeName)
        return len(non_required_fields) != 0


class VersionFormatIncorrect(Lint):
    name = "the version value is invalid"
    recommendation = "see the Contributing Wiki for guidance on the version string"

    def check(self, path):
        dom = minidom.parse(str(path))
        metadata = dom.getElementsByTagName("metadata")[0]

        version = metadata.getElementsByTagName("version")[0]
        version = version.firstChild.data.split(".")
        if len(version) > 4:
            print(f"{path} more than four version segments: {version}")
            return True

        if len(version) == 4:
            try:
                datetime.datetime.strptime(version[3], "%Y%m%d")
            except ValueError:
                print(f"{path} fourth version segment not in format %Y%m%d")
                return True

        # for metapackage with locked dependency version
        deps = dom.getElementsByTagName("dependencies")
        if len(deps) == 1:
            for d in deps[0].childNodes:
                if d.nodeName == "dependency" and d.getAttribute("version"):
                    dep_version = d.getAttribute("version")
                    if dep_version.startswith("[") and dep_version.endswith("]"):
                        dep_version = dep_version[1:-1].split(".")
                        if len(dep_version) == 4:
                            if dep_version[:3] != version[:3]:
                                print(f"{path} package version should be {'.'.join(dep_version[:3])}")
                                return True
                        elif dep_version != version:
                            print(f"{path} package version should be {'.'.join(dep_version)}")
                            return True

        return False


class DoesNotListDependencyCommonVm(Lint):
    name = "does not depend on common.vm"
    recommendation = "add the common.vm dependency"

    def check(self, path):
        if "common.vm" in str(path):
            return False

        dom = minidom.parse(str(path))
        deps = dom.getElementsByTagName("dependencies")
        if len(deps) != 1:
            return True

        for d in deps[0].childNodes:
            if d.nodeName == "dependency" and d.getAttribute("id") == "common.vm":
                return False
        return True


NUSPEC_LINTS = (
    IncludesRequiredFieldsOnly(),
    VersionFormatIncorrect(),
    DoesNotListDependencyCommonVm(),
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
    FIRST_LINE = "$ErrorActionPreference = 'Stop'"
    name = "first line must set error handling to stop"
    recommendation = f"add `{FIRST_LINE}` to the file"

    def check(self, path):
        # utf-8-sig ignores BOM
        with open(path, "r", encoding="utf-8-sig") as f:
            lines = f.read().splitlines()

        return not self.FIRST_LINE == lines[0]


INSTALL_LINTS = (
    MissesImportCommonVm(),
    FirstLineDoesNotSetErrorAction(),
)


def lint_install(path):
    return run_lints(INSTALL_LINTS, path)


def lint(path) -> Dict[str, list]:
    ret = {}
    for root, dirs, files in os.walk(path):
        for name in files:
            if name.endswith(".md"):
                continue

            violations = list()

            path = pathlib.Path(os.path.join(root, name))

            violations.extend(list(lint_path(path)))

            if ".nuspec" in name:
                violations.extend(lint_nuspec(path))
            elif "chocolateyinstall.ps1" in name:
                violations.extend(lint_install(path))

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
