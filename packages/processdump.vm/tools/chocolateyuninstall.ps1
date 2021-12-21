$ErrorActionPreference = 'Continue'
Import-Module vm.common -Force -DisableNameChecking

$toolName = "pd"
$category = "Utilities"

VM-Remove-Tool-Shortcut ($toolName + "32") $category
VM-Remove-Tool-Shortcut ($toolName + "64") $category
