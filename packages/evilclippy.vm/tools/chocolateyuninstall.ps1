$ErrorActionPreference = 'Continue'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'EvilClippy'
$category = 'Payload Development'

VM-Uninstall $toolName $category
