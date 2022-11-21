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

# categories must be synchronized with the issue templates
CATEGORIES = (
    "Android",
    "Debuggers",
    "Delphi",
    "Disassemblers",
    "dotNet",
    "Forensic",
    "Hex Editors",
    "Java",
    "Javascript",
    "Networking",
    "Office",
    "PDF",
    "PE",
    "PowerShell",
    "Python",
    "Text Editors",
    "Utilities",
    "VB",
    # CommandoVM
    "Active Directory",
    "Command & Control",
    "Evasion",
    "Exploitation",
    "Information Gathering",
    "Password Attacks",
    "Vulnerability Analysis",
    "Web Application",
    "Wordlists",
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
    tool_name="...", category="...", target_url="...", target_hash="..."
"""
ZIP_EXE_TEMPLATE = r"""$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = '{tool_name}'
$category = '{category}'

$zipUrl = '{target_url}'
$zipSha256 = '{target_hash}'

VM-Install-From-Zip $toolName $category $zipUrl -zipSha256 $zipSha256
"""

"""
Needs the following format strings:
    tool_name="...", category="...", target_url="...", target_hash="..."
"""
GITHUB_REPO_TEMPLATE = r"""$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = '{tool_name}'
$category = '{category}'

$zipUrl = '{target_url}'
$zipSha256 = '{target_hash}'

VM-Install-Raw-GitHub-Repo $toolName $category $zipUrl $zipSha256
"""

"""
Needs the following format strings:
    tool_name="...", category="...", shim_path="..."
"""
METAPACKAGE_TEMPLATE = r"""$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

try {{
  $toolName = '{tool_name}'
  $category = '{category}'
  $shimPath = '{shim_path}'

  $shortcutDir = Join-Path ${{Env:TOOL_LIST_DIR}} $category
  $shortcut = Join-Path $shortcutDir "$toolName.lnk"
  $executablePath = Join-Path ${{Env:ChocolateyInstall}} $shimPath -Resolve
  Install-ChocolateyShortcut -shortcutFilePath $shortcut -targetPath $executablePath -RunAsAdmin
  VM-Assert-Path $shortcut
}} catch {{
  VM-Write-Log-Exception $_
}}
"""

"""
Needs the following format strings:
    tool_name="...", category="...", target_url="...", target_hash="..."
"""
SINGLE_EXE_TEMPLATE = r"""$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = '{tool_name}'
$category = '{category}'

$exeUrl = '{target_url}'
$exeSha256 = '{target_hash}'

VM-Install-Single-Exe $toolName $category $exeUrl -exeSha256 $exeSha256
"""

"""
Needs the following format strings:
    tool_name="...", category="...", target_url="...", target_hash="..."
"""
SINGLE_PS1_TEMPLATE = r"""$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = '{tool_name}'
$category = '{category}'

$ps1Url = '{target_url}'
$ps1Sha256 = '{target_hash}'

VM-Install-Single-Ps1 $toolName $category $ps1Url -ps1Sha256 $ps1Sha256
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
        target_url=kwargs.get("target_url"),
        target_hash=kwargs.get("target_hash"),
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
        target_url=kwargs.get("target_url"),
        target_hash=kwargs.get("target_hash"),
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
        tool_name=kwargs.get("tool_name"),
        category=kwargs.get("category"),
        dependency=kwargs.get("dependency"),
        shim_path=kwargs.get("shim_path"),
    )


def create_single_exe_template(packages_path, **kwargs):
    create_template(
        SINGLE_EXE_TEMPLATE,
        packages_path=packages_path,
        pkg_name=kwargs.get("pkg_name"),
        version=kwargs.get("version"),
        authors=kwargs.get("authors"),
        description=kwargs.get("description"),
        tool_name=kwargs.get("tool_name"),
        category=kwargs.get("category"),
        target_url=kwargs.get("target_url"),
        target_hash=kwargs.get("target_hash"),
    )


def create_single_ps1_template(packages_path, **kwargs):
    create_template(
        SINGLE_PS1_TEMPLATE,
        packages_path=packages_path,
        pkg_name=kwargs.get("pkg_name"),
        version=kwargs.get("version"),
        authors=kwargs.get("authors"),
        description=kwargs.get("description"),
        tool_name=kwargs.get("tool_name"),
        category=kwargs.get("category"),
        target_url=kwargs.get("target_url"),
        target_hash=kwargs.get("target_hash"),
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
    target_url="",
    target_hash="",
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
                target_url=target_url,
                target_hash=target_hash,
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


# dict[str, dict[str, any]]
TYPES = {
    "ZIP_EXE": {
        "cb": create_zip_exe_template,
        "doc": "An executable tool distributed in a ZIP file",
        "example": "<url>/tool.zip",
        "arguments": [
            "pkg_name",
            "version",
            "authors",
            "description",
            "tool_name",
            "category",
            "target_url",
            "target_hash",
        ],
    },
    "SINGLE_EXE": {
        "cb": create_single_exe_template,
        "doc": "An executable tool distributed via direct/raw download",
        "example": "<url>/tool.exe",
        "arguments": [
            "pkg_name",
            "version",
            "authors",
            "description",
            "tool_name",
            "category",
            "target_url",
            "target_hash",
        ],
    },
    "SINGLE_PS1": {
        "cb": create_single_ps1_template,
        "doc": "A PowerShell script distributed via direct/raw download",
        "example": "<url>/script.ps1",
        "arguments": [
            "pkg_name",
            "version",
            "authors",
            "description",
            "tool_name",
            "category",
            "target_url",
            "target_hash",
        ],
    },
    "GITHUB_REPO": {
        "cb": create_git_repo_template,
        "doc": "Download a GitHub repository based on a specific commit hash",
        "example": "https://github.com/sense-of-security/ADRecon/archive/38e4abae3e26d0fa87281c1d0c65cabd4d3c6ebd.zip",
        "arguments": [
            "pkg_name",
            "version",
            "authors",
            "description",
            "tool_name",
            "category",
            "target_url",
            "target_hash",
        ],
    },
    "METAPACKAGE": {
        "cb": create_metapackage_template,
        "doc": "Install and configure existing packages via dependencies",
        "example": "Install a <tool> already available via chocolatey.org",
        "arguments": [
            "pkg_name",
            "version",
            "authors",
            "description",
            "tool_name",
            "category",
            "dependency",
            "shim_path",
        ],
    },
}


def have_all_required_args(type_, args):
    typ = TYPES.get(type_)
    required_args = typ["arguments"]
    for required_arg in required_args:
        if not args.get(required_arg):
            print(f"{type_}: {typ['doc']}, e.g., {typ['example']}")
            print(f" missing argument: {required_arg}")
            print(f" requires: {', '.join(required_args)}")
            return False
    return True


def main(argv=None):
    if argv is None:
        argv = sys.argv[1:]

    epilog = textwrap.dedent(
        """
    Example usage:
      python %(prog)s --pkg_name <> --version <> --authors <> --tool_name <> --category <>
    """
    )
    parser = argparse.ArgumentParser(description="A CLI tool to create package templates.", epilog=epilog)
    parser.add_argument("--pkg_name", type=str, help="Package name without suffix (i.e., no '.vm' needed)")
    parser.add_argument("--version", type=str, help="Tool's version number")
    parser.add_argument("--authors", type=str, help="Comma separated list of authors for tool")
    parser.add_argument("--tool_name", type=str, help="Name of tool (usually the file name with the '.exe')")
    parser.add_argument("--category", type=str, choices=CATEGORIES, help="Category for tool")
    parser.add_argument("--description", type=str, default="", help="Description for tool")
    parser.add_argument("--dependency", type=str, default="", help="Metapackage dependency")
    parser.add_argument("--target_url", type=str, default="", help="URL to target file (zip or executable)")
    parser.add_argument("--target_hash", type=str, default="", help="SHA256 hash of target file (zip or executable)")
    parser.add_argument("--shim_path", type=str, default="", help="Metapackage shim path")
    parser.add_argument("--type", type=str, choices=TYPES.keys(), nargs="?", help="Template type")
    args = parser.parse_args(args=argv)

    if args.type is None:
        print(f"{'type'.ljust(15)} {'description'.ljust(60)} {'example'}")
        for k, t in TYPES.items():
            print(f"{k.ljust(15)} {t['doc'].ljust(60)} {t['example']}")
        return 0

    if not have_all_required_args(args.type, args.__dict__):
        return -1

    root_dir = os.path.dirname(os.path.dirname(get_script_directory()))
    packages_path = os.path.join(root_dir, "packages")

    create_type_template_cb = TYPES.get(args.type)["cb"]

    # remove type before passing to template create function
    del args.type

    create_type_template_cb(packages_path, **vars(args))

    return 0


if __name__ == "__main__":
    main()
