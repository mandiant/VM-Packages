$ErrorActionPreference = 'Continue'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'ipython'
$category = 'Productivity Tools'

VM-Uninstall-With-Pip -toolName $toolName -category $category
