$ErrorActionPreference = 'Continue'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'VSCode'
$category = 'Text Editors'

VM-Remove-Tool-Shortcut $toolName $category
