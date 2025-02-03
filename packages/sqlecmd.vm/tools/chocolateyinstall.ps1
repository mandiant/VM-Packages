$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'SQLECmd'
$category = 'Forensic'
$zipUrl = 'https://download.mikestammer.com/net6/SQLECmd.zip'

VM-Install-From-Zip $toolName $category $zipUrl -consoleApp $true -innerFolder $true -verifySignature $true
