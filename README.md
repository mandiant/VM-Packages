[![daily check](https://github.com/mandiant/VM-packages/workflows/daily/badge.svg)](https://github.com/mandiant/VM-packages/actions?query=workflow%3Adaily+branch%3Amain)
[![CI](https://github.com/mandiant/VM-packages/workflows/CI/badge.svg)](https://github.com/mandiant/VM-packages/actions?query=workflow%3ACI+branch%3Amain)

# Virtual Machine Packages

## Overview
This repository contains the source code for packages supporting the projects below:
* [FLARE-VM](https://github.com/mandiant/flare-vm)
* [Commando-VM](https://github.com/mandiant/commando-vm)
* [ThreatPursuit-VM](https://github.com/mandiant/ThreatPursuit-VM)

> NOTE: Packages do not contain actual software distributions. Packages are PowerShell scripts that only contain instructions for obtaining distributions. See [Chocolatey legal information](https://docs.chocolatey.org/en-us/information/legal) for more details.

### Package Lifecycle
Below is a summary of a package's lifecycle from source code to tool installation:

1. Package source code committed
2. Package built and pushed to MyGet repository
   - A built package is a `.nupkg` file that's essentially a ZIP file of the package source code
   - GitHub actions will perform building/pushing to MyGet; however, repo admins may need to manually build/push packages occasionally
3. User runs installation script for:
   - [FLARE-VM](https://github.com/mandiant/flare-vm)
   - [Commando-VM](https://github.com/mandiant/commando-vm)
   - [ThreatPursuit-VM](https://github.com/mandiant/ThreatPursuit-VM)
4. Installation script downloads built package (aka `.nupkg` file) from MyGet
   - The installation script contains a list of packages to install (e.g., [packages.json](https://github.com/mandiant/flare-vm/blob/master/flarevm.installer.flare/tools/packages.json))
5. Installation script installs the package which in turn performs the actions below:
   - Package contains a tool's URL link
   - Package downloads and installs tool to the User's system

## Why Open-Source the Package Code?
Open-sourcing the package source code provides the community an avenue to both fix broken packages and submit new packages.

### Additional Benefits: Automation
Once a package is submitted, our PR hooks will test the package to see if it builds and installs correctly. Additionally, GitHub actions can automatically build and test each package on a daily or weekly basis to check if a package has broke. The awareness of broken packages is a large problem by itself which these actions can alleviate.

## How do I Create a Package?
Please see the Wiki for documentation on how to create a package using our established best practices.