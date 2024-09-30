$ErrorActionPreference = 'Continue'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'js-beautify'
$category = 'Javascript'

VM-Uninstall $toolName $category
