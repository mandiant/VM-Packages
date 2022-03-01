import os
import sys
import logging
import argparse
import textwrap

# Set up logger
logging.basicConfig(
    format="%(asctime)s %(levelname)-8s [%(filename)s:%(lineno)d] %(message)s",
    level=logging.INFO,
    datefmt="%H:%M:%S",
    stream=sys.stderr,
)
logger = logging.getLogger(__name__)
logger.setLevel(logging.DEBUG)

CATEGORIES = (
    "Android",
    "Debuggers",
    "Decompilers",
    "Delphi",
    "Developer Tools",
    "Disassemblers",
    "dotNet",
    "Flash",
    "Forensic",
    "Hex Editors",
    "Java",
    "Javascript",
    "Net",
    "Office",
    "PDF",
    "Pentest",
    "PowerShell",
    "Python",
    "Text Editors",
    "Utilities",
    "VB",
    "Web Application",
)

UNINSTALL_TEMPLATE_NAME = "chocolateyuninstall.ps1"
INSTALL_TEMPLATE_NAME = "chocolateyinstall.ps1"

"""
Needs the following format strings:
    pkg_name="...", version="...", authors="...", description="..."
"""
NUSPEC_TEMPLATE_NAME = "{}.vm.nuspec"
NUSPEC_TEMPLATE = r"""<?xml version="1.0" encoding="utf-8"?>
<package xmlns="http://schemas.microsoft.com/packaging/2015/06/nuspec.xsd">
  <metadata>
    <id>{pkg_name}.vm</id>
    <version>{version}</version>
    <authors>{authors}</authors>
    <description>{description}</description>
    <dependencies>
      <dependency id="common.vm" />
    </dependencies>
  </metadata>
</package>
"""

"""
Needs the following format strings:
    pkg_name="...", version="...", authors="...", description="...", dependency="..."
"""
NUSPEC_TEMPLATE_METAPACKAGE = r"""<?xml version="1.0" encoding="utf-8"?>
<package xmlns="http://schemas.microsoft.com/packaging/2015/06/nuspec.xsd">
  <metadata>
    <id>{pkg_name}.vm</id>
    <version>{version}</version>
    <authors>{authors}</authors>
    <description>{description}</description>
    <dependencies>
      <dependency id="common.vm" />
      <dependency id="{dependency}" version="[{version}]" />
    </dependencies>
  </metadata>
</package>
"""

"""
Needs the following format strings:
    tool_name="...", category="...", zip_url="...", zip_hash="..."
"""
ZIP_EXE_TEMPLATE = r"""$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = '{tool_name}'
$category = '{category}'

$zipUrl = '{zip_url}'
$zipSha256 = '{zip_hash}'

VM-Install-From-Zip $toolName $category $zipUrl $zipSha256
"""


"""
Needs the following format strings:
    tool_name="...", category="...", zip_url="...", zip_hash="..."
"""
GITHUB_REPO_TEMPLATE = r"""$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = '{tool_name}'
$category = '{category}'

$zipUrl = '{zip_url}'
$zipSha256 = '{zip_hash}'

VM-Install-Raw-GitHub-Repo $toolName $category $zipUrl $zipSha256
"""


"""
Needs the following format strings:
    tool_name="...", category="...", shim_path="..."
"""
METAPACKAGE_TEMPLATE = r"""$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

try {{
  $toolLnk = '{tool_name}.lnk'
  $category = '{category}'
  $shimPath = '{shim_path}'

  $shortcutDir = Join-Path ${{Env:TOOL_LIST_DIR}} $category
  $shortcut = Join-Path $shortcutDir $toolLnk
  $executablePath = Join-Path ${{Env:ChocolateyInstall}} $shimPath -Resolve
  Install-ChocolateyShortcut -shortcutFilePath $shortcut -targetPath $executablePath -RunAsAdmin
  VM-Assert-Path $shortcut
}} catch {{
  VM-Write-Log-Exception $_
}}
"""


"""
Needs the following format strings:
    tool_name="...", category="..."
"""
GENERIC_UNINSTALL_TEMPLATE = r"""$ErrorActionPreference = 'Continue'
Import-Module vm.common -Force -DisableNameChecking

$toolName = '{tool_name}'
$category = '{category}'

VM-Uninstall $toolName $category
"""

"""
Needs the following format strings:
    tool_name="...", category="..."
"""
METAPACKAGE_UNINSTALL_TEMPLATE = r"""$ErrorActionPreference = 'Continue'
Import-Module vm.common -Force -DisableNameChecking

$toolName = '{tool_name}'
$category = '{category}'

VM-Remove-Tool-Shortcut $toolName $category
"""


def create_git_repo_template(packages_path, **kwargs):
    create_template(
        GITHUB_REPO_TEMPLATE,
        packages_path=packages_path,
        pkg_name=kwargs.get("pkg_name"),
        version=kwargs.get("version"),
        authors=kwargs.get("authors"),
        description=kwargs.get("description"),
        tool_name=kwargs.get("tool_name"),
        category=kwargs.get("category"),
        zip_url=kwargs.get("zip_url"),
        zip_hash=kwargs.get("zip_hash"),
    )


def create_zip_exe_template(packages_path, **kwargs):
    create_template(
        ZIP_EXE_TEMPLATE,
        packages_path=packages_path,
        pkg_name=kwargs.get("pkg_name"),
        version=kwargs.get("version"),
        authors=kwargs.get("authors"),
        description=kwargs.get("description"),
        tool_name=kwargs.get("tool_name"),
        category=kwargs.get("category"),
        zip_url=kwargs.get("zip_url"),
        zip_hash=kwargs.get("zip_hash"),
    )


def create_metapackage_template(packages_path, **kwargs):
    create_template(
        METAPACKAGE_TEMPLATE,
        nuspec_template=NUSPEC_TEMPLATE_METAPACKAGE,
        uninstall_template=METAPACKAGE_UNINSTALL_TEMPLATE,
        packages_path=packages_path,
        pkg_name=kwargs.get("pkg_name"),
        version=kwargs.get("version"),
        authors=kwargs.get("authors"),
        description=kwargs.get("description"),
        dependency=kwargs.get("dependency"),
        tool_name=kwargs.get("tool_name"),
        category=kwargs.get("category"),
        shim_path=kwargs.get("shim_path"),
    )


def create_template(
    template="",
    nuspec_template=NUSPEC_TEMPLATE,
    uninstall_template=GENERIC_UNINSTALL_TEMPLATE,
    packages_path="",
    pkg_name="",
    version="",
    authors="",
    description="",
    tool_name="",
    category="",
    zip_url="",
    zip_hash="",
    shim_path="",
    dependency="",
):
    pkg_path = os.path.join(packages_path, f"{pkg_name}.vm")
    try:
        os.makedirs(pkg_path)
    except:
        logger.debug(f"Directory already exists: {pkg_path}")

    tools_path = os.path.join(pkg_path, "tools")
    try:
        os.makedirs(tools_path)
    except:
        logger.debug(f"Directory already exists: {tools_path}")

    with open(os.path.join(pkg_path, NUSPEC_TEMPLATE_NAME.format(pkg_name)), "w") as f:
        f.write(
            nuspec_template.format(
                pkg_name=pkg_name,
                version=version or "0.0.0",
                authors=authors,
                description=description,
                dependency=dependency,
            )
        )

    with open(os.path.join(tools_path, INSTALL_TEMPLATE_NAME), "w") as f:
        f.write(
            template.format(
                tool_name=tool_name,
                category=category,
                zip_url=zip_url,
                zip_hash=zip_hash,
                shim_path=shim_path,
            )
        )

    with open(os.path.join(tools_path, UNINSTALL_TEMPLATE_NAME), "w") as f:
        f.write(uninstall_template.format(tool_name=tool_name, category=category))


def get_script_directory():
    path = os.path.realpath(sys.argv[0])
    if os.path.isdir(path):
        return path
    else:
        return os.path.dirname(path)


if __name__ == "__main__":
    # TODO define required arguments per type
    # dict[str, Callable]
    TYPES = {
        "ZIP_EXE": create_zip_exe_template,
        "GITHUB_REPO": create_git_repo_template,
        "METAPACKAGE": create_metapackage_template,
    }

    epilog = textwrap.dedent(
        """
    Example usage:
      python %(prog)s --pkg_name <> --version <> --authors <> --tool_name <> --category <>
    """
    )
    parser = argparse.ArgumentParser(description="A CLI tool to create package templates.", epilog=epilog)
    parser.add_argument(
        "--pkg_name", type=str, required=True, help="Package name without suffix (i.e., no '.vm' needed)"
    )
    parser.add_argument("--version", type=str, required=True, help="Tool's version number")
    parser.add_argument("--authors", type=str, required=True, help="Comma separated list of authors for tool")
    parser.add_argument(
        "--tool_name", type=str, required=True, help="Name of tool (usually the file name with the '.exe')"
    )
    parser.add_argument("--category", type=str, choices=CATEGORIES, required=True, help="Category for tool")
    parser.add_argument("--description", type=str, default="", required=False, help="Description for tool")
    parser.add_argument("--dependency", type=str, default="", required=False, help="Metapackage dependency")
    parser.add_argument("--zip_url", type=str, default="", required=False, help="URL to ZIP file")
    parser.add_argument("--zip_hash", type=str, default="", required=False, help="SHA256 hash of ZIP file")
    parser.add_argument("--shim_path", type=str, default="", required=False, help="Metapackage shim path")
    parser.add_argument("--type", type=str, choices=TYPES.keys(), required=True, help="Template type.")
    args = parser.parse_args()

    root_dir = os.path.dirname(os.path.dirname(get_script_directory()))
    packages_path = os.path.join(root_dir, "packages")

    create_type_template_cb = TYPES.get(args.type)

    # remove type before passing to template create function
    del args.type

    create_type_template_cb(packages_path, **vars(args))
