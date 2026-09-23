$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'GoReSym'
$category = VM-Get-Category($MyInvocation.MyCommand.Definition)

$zipUrl = 'https://github.com/mandiant/GoReSym/releases/download/v3.4.1/GoReSym-windows.zip'
$zipSha256 = 'c051f182412197d834bd3cbd91424831b7aadb85dfe6548603873672560a8dea'

VM-Install-From-Zip $toolName $category $zipUrl -zipSha256 $zipSha256 -consoleApp $true -arguments "--help"
