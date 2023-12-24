# Common Module and Environment Variables for Customization
This serves to document the customization options and shared PowerShell module.

**TL;DR** - The package `common.vm` is now a dependency for all VM-packages. It provides a PowerShell module with many helper functions shared by our packages. It also allows customization via environment variables.

## Environment Variable Customizations
We use environment variables to specify where certain items should be located. Some of these environment variables are now configurable by the user. Below outlines the configurable variables and provides a brief description.

### User Configurable
The environment variables below are configurable by the user:
- `VM_COMMON_DIR`
  - Default Path:
    - *`%PROGRAMDATA%`*`\_VM`
  - Use:
    - VM common directory containing anything related to VM-packages (e.g., shared module, log file, saved config file, etc...)
- `TOOL_LIST_DIR`
  - Default Path:
    - *`%USERPROFILE%`*`\Desktop\Tools`
  - Use:
    - Path to a directory containing tool shortcuts
- `RAW_TOOLS_DIR`
  - Default Path:
    - *`%SYSTEMDRIVE%`*`\Tools`
  - Use:
    - Directory where actual tools may be installed if not installed to the default Chocolatey package directory

## Common PowerShell Module
We have implemented a PowerShell module that provides commonly used functions. Any package may now make use of these common functions to reduce duplication. The module is saved to: *`%PROGRAMDATA%`*`\_VM\vm.common\vm.common.psm1`

