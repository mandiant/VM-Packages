[![Packages](https://img.shields.io/badge/packages-53-blue.svg)](packages)
[![CI](https://github.com/mandiant/VM-packages/workflows/CI/badge.svg)](https://github.com/mandiant/VM-packages/actions?query=workflow%3ACI+branch%3Amain)
[![Daily run success](https://img.shields.io/badge/pkgs--install--pass-49-green.svg)](https://github.com/mandiant/VM-packages/actions?query=workflow%3Adaily+branch%3Amain)
[![Daily run failure](https://img.shields.io/badge/pkgs--install--fail-3-orange.svg)](https://github.com/mandiant/VM-packages/actions?query=workflow%3Adaily+branch%3Amain)

# Virtual Machine Packages

This repository contains the source code for packages supporting the following analysis environment projects:
* [FLARE VM](https://github.com/mandiant/flare-vm)
* [CommandoVM](https://github.com/mandiant/commando-vm)
* [ThreatPursuit VM](https://github.com/mandiant/ThreatPursuit-VM)

> Packages do not contain actual software distributions. Packages are PowerShell scripts that only contain instructions for obtaining and configuring tools. See [Chocolatey legal information](https://docs.chocolatey.org/en-us/information/legal) for more details.

# How does this work?
The packages stored in this repository are automatically built and pushed to a public package feed hosted on myget.org. From this feed FLARE VM and our other binary analysis environments download packages and execute the included scripts to install tools.

The installation of packages relies on [Chocolatey](https://chocolatey.org/).

# Contributing
To report problems or to suggest new tools please open a new [Issue](https://github.com/mandiant/VM-Packages/issues).

Please see the [Wiki](https://github.com/mandiant/VM-Packages/wiki) for documentation on how to create a package using our established best practices.

# Open Source Packages
Open sourcing the installation packages allows the community to not only suggest new tools, improvements, and report bugs, but to help implement them. It's now very transparent how and what gets installed. Moreover, we can use GitHub Actions (free for open-source repositories) for testing and automations. This reduces manual maintenance and simplifies contributions.

## Automation
Once a package is submitted, our pull request automations test the package to see if it builds and installs correctly. Additionally, we use GitHub Actions to build and test each package on a daily basis to check for any errors. Simply being aware of broken packages should quickly solve a lot of problems VM users faced in the past.
