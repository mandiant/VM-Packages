$ErrorActionPreference = 'Continue'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'VNC-Viewer'
$category = 'Utilities'

VM-Remove-Tool-Shortcut $toolName $category
