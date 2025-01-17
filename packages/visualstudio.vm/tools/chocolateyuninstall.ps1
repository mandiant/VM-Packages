$ErrorActionPreference = 'Continue'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'VisualStudio'
$category = 'Productivity Tools'

VM-Remove-Tool-Shortcut $toolName $category

# Refresh Desktop as shortcut is used in FLARE-VM LayoutModification.xml
VM-Refresh-Desktop

choco uninstall visualstudio2022community --removedependencies
