$ErrorActionPreference = 'Continue'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'keystone-engine'

VM-Pip-Uninstall $toolName
