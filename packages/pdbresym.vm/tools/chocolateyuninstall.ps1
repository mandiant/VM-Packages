$ErrorActionPreference = 'Continue'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'PDBReSym'
$category = 'Utilities'

# Uninstalling only removes the tool not the downloaded symbols
VM-Uninstall $toolName $category
