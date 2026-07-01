$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'GoReSym'
$category = VM-Get-Category($MyInvocation.MyCommand.Definition)

$zipUrl = 'https://github.com/mandiant/GoReSym/releases/download/v3.4/GoReSym-windows.zip'
$zipSha256 = '6b9c0680bc0b16759698d26a89ff3c98fe70511948830da5e041d71e9ffdc6c0'

VM-Install-From-Zip $toolName $category $zipUrl -zipSha256 $zipSha256 -consoleApp $true -arguments "--help"
