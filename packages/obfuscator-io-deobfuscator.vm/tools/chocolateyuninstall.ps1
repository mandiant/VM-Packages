$ErrorActionPreference = 'Continue'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'obfuscator-io-deobfuscator'
$category = 'Javascript'

VM-Remove-Tool-Shortcut $toolName $category
