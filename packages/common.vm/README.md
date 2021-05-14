# Common Module and Env Vars for Customization
This serves to document the customization options and commonly shared PowerShell module.

**TL;DR** - The package `Common.vm` is now a dependency for all VM-packages. It allows for new user customizations and provides a PowerShell module with many helper functions shared by our packages.

## Environment Variable Customizations
We use environment variables to specify where certain items should be located. Some of these environment variables are now configurable by the user. Below outlines the configurable variables and provides a brief description.

### Non-User Configurable
The environment variable below is NOT currently configurable by the user:
- `VM_COMMON_DIR`
  - Default Path:
    - *`%PROGRAMDATA%`*`\vm.common`
  - Use:
    - VM common directory. Can contain anything related to VM-packages.
    - Used to store `vm.common.psm1`

### User Configurable
The environment variables below are configurable by the user:
- `TOOL_LIST_DIR`
  - Default Path:
    - *`%PROGRAMDATA%`*`\Microsoft\Windows\Start Menu\Programs\Tools`
  - Use:
    - Path to a directory containing various tool shortcuts
- `TOOL_LIST_SHORTCUT`
  - Default Path:
    - *`%USERPROFILE%`*`\Desktop\Tools.lnk`
  - Use:
    - Path to a shortcut file (`.lnk`) that points to *`%TOOL_LIST_DIR%`*
- `RAW_TOOLS_DIR`
  - Default Path:
    - *`%SYSTEMDRIVE%`*`\Tools`
  - Use:
    - Common directory where actual tools may be installed if not installed to the default Chocolatey package directory

## Common PowerShell Module
We have implemented a new PowerShell module that provides commonly used functions. Any package may now make use of these common functions to reduce duplication.
