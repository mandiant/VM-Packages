[![Packages](https://gist.githubusercontent.com/vm-packages/0e28118f551692f3401ac669e1d6761d/raw/packages_badge.svg)](packages)
[![Daily run failures Windows 2022](https://gist.githubusercontent.com/vm-packages/7d6b2592948d916eb5529350308f01d1/raw/windows-2022_daily_badge.svg)](https://github.com/mandiant/VM-Packages/wiki/Daily-Failures)
[![Daily run failures Windows 2025](https://gist.githubusercontent.com/vm-packages/7d6b2592948d916eb5529350308f01d1/raw/windows-2025_daily_badge.svg)](https://github.com/mandiant/VM-Packages/wiki/Daily-Failures)
[![MyGet version mismatches](https://gist.githubusercontent.com/vm-packages/dfe6ed22576b6c1d2fa749ff46f3bc6f/raw/myget_badge.svg)](https://github.com/mandiant/VM-Packages/wiki/MyGet-Version-Mismatches)
[![CI](https://github.com/mandiant/VM-packages/workflows/CI/badge.svg)](https://github.com/mandiant/VM-packages/actions?query=workflow%3ACI+branch%3Amain)

# Virtual Machine Packages

This repository contains the source code for packages supporting the following analysis environment projects:
* [FLARE VM](https://github.com/mandiant/flare-vm)
* [CommandoVM](https://github.com/mandiant/commando-vm)

> Packages do not contain actual software distributions.
> Packages are PowerShell scripts that only contain instructions for obtaining and configuring tools.
> See [Chocolatey legal information](https://docs.chocolatey.org/en-us/information/legal) for more details.


# How does this work?

The packages stored in this repository are automatically built and pushed to a public [package feed hosted on MyGet](https://www.myget.org/feed/Packages/vm-packages).
From this feed FLARE VM and our other binary analysis environments download packages and execute the included scripts to install tools.
The installation of packages relies on [Chocolatey](https://chocolatey.org/).


## Open Source Packages

Open sourcing the installation packages allows the community to not only suggest new tools, improvements, and report bugs, but to help implement them.
It's now transparent how and what gets installed.
Moreover, we can use GitHub Actions (free for open-source repositories) for testing and automation.
This reduces manual maintenance and simplifies contributions.


## Automation using GitHub Actions

Once a package is submitted, our pull request automation test the package to see if it builds and installs correctly.
Additionally, we build and test each package on a daily basis to check for any errors.
Simply being aware of broken packages should quickly solve a lot of problems VM users faced in the past.
To see the daily test results check the [Daily Failures](https://github.com/mandiant/VM-Packages/wiki/Daily-Failures) and [MyGet Version Mismatches](https://github.com/mandiant/VM-Packages/wiki/MyGet-Version-Mismatches) wiki pages.
The status is also displayed in the badges at the beginning of this README.

We have also automated other task, such as the creation of new packages (using [`create_package_template.py`](https://github.com/mandiant/VM-Packages/blob/main/scripts/utils/create_package_template.py)) and the package updates (using [`update_package.py`](https://github.com/mandiant/VM-Packages/blob/main/scripts/utils/update_package.py)).


## Documentation

- Check our [CONTRIBUTING guide](/CONTRIBUTING.md) to learn how to contribute to the project.
- Check our [Wiki](https://github.com/mandiant/VM-Packages/wiki) for documentation on how to create a package using our established best practices.
