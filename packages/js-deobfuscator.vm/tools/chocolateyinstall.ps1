$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'js-deobfuscator'
$category = 'Javascript'

VM-Install-Node-Tool -toolName $toolName -category $category -arguments "--help"
