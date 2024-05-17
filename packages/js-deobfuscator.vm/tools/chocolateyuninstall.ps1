$ErrorActionPreference = 'Continue'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'js-deobfuscator'
$category = 'Javascript'

VM-Uninstall $toolName $category
