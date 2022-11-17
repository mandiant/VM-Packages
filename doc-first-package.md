# My first package walk-through
You're missing a good analysis tools in this package repository?
See below on how you can create the package via a GitHub issue or manually with the support of a package template script.

Manual package creation is the more versatile route and could lead to faster results if you're already familiar with the package structure and installation functions.

However, the issue driven package creation, can fully streamline the addition of a new tool. In the best case:
* you submit an issue with the required package metadata
* a package pull request gets automatically created, after a maintainer approved it
* the package gets tested and pushed to the package feed

### Chocolatey
FLARE VM uses Chocolatey. Read their great documentation at https://docs.chocolatey.org/en-us/create/create-packages to learn more about the general package creation process.
For this project we do not use self-contained packages or packages that contain the actual binaries. Instead we use packages that obtain the files from the web at runtime.

## Automatic package pull request via new issue
* go to [Issues](https://github.com/mandiant/VM-Packages/issues) - [New Issue](https://github.com/mandiant/VM-Packages/issues/new/choose)
* select the appropriate package type
  * for packages that install another package via dependencies select "NEW METAPACKAGE"
  * for all other packages select "NEW PACKAGE"
* fill out the required fields
* submit your new issue
* a maintainer will review your submission and label it for automatic package creation
  * the automated processing includes linting and testing
* if changes are required, download the created branch and modify it locally
  * see GitHub's documentation on [Checking out pull requests locally](https://docs.github.com/en/pull-requests/collaborating-with-pull-requests/reviewing-changes-in-pull-requests/checking-out-pull-requests-locally)
  * depending on your permissions you may have to [create a new pull request](https://docs.github.com/en/articles/creating-a-pull-request) with your new branch 

## Manual package creation
* find the appropriate package type
  * see supported options via `$ python scripts/utils/create_package_template.py --type`
  * also see `$python scripts/utils/create_package_template.py -h` for detailed usage information
* see required arguments via `$ python scripts/utils/create_package_template.py --type <package_type>`
* provide required arguments, for example for:
  * type `METAPACKAGE`
  ```
  $ python scripts/utils/create_package_template.py \
    --type METAPACKAGE \
    --pkg_name dnspyex \
    --tool_name dnSpyEx \
    --version 6.2.0 \
    --category dotNet \
    --authors '0xd4d, ElektroKill' \
    --description 'dnSpyEx is ...' \
    --dependency 'dnSpyEx' \
    --shim_path '%PROGRAMDATA%\chocolatey\bin\dnSpy.exe'
  ``` 
  * type `ZIP_EXE`
  ```
  $ python scripts/utils/create_package_template.py \
    --type ZIP_EXE \
    --pkg_name floss \
    --tool_name flare-floss \
    --version 2.1.0 \
    --authors Mandiant \
    --description 'FLOSS ...' \
    --category Utilities \
    --target_url https://github.com/mandiant/flare-floss/releases/download/v2.1.0/floss-v2.1.0-windows.zip \
    --target_hash 925df10403b45e29914e44ac50d92d762b2b2499c11cdd1801888aac95b53eb7
  ```
* ensure scripts and package meet code and structure requirements
  * see the [Wiki](https://github.com/mandiant/VM-Packages/wiki/Contributing)
  * lint PowerShell code: `PS scripts/test/lint.ps1` (requires `psscriptanalyzer`, see `lint.ps1` contents)
  * lint all packages `$ python scripts/test/lint.py packages`
* test package installation
  * `PS scripts/test/test_install.ps1 "common.vm <package>"`
* test package uninstallation
  * `PS scripts/test/test_uninstall.ps1 <package>`
* if required: modify package to fix issues
* submit a pull request
