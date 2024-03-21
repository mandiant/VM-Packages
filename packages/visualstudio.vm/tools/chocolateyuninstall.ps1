$ErrorActionPreference = 'Continue'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'VisualStudio'
$category = 'Productivity Tools'

VM-Remove-Tool-Shortcut $toolName $category

choco uninstall visualstudio2022community --removedependencies
