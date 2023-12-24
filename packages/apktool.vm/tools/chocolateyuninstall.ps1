$ErrorActionPreference = 'Continue'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'apktool'
$category = 'Java & Android'

VM-Remove-Tool-Shortcut $toolName $category
