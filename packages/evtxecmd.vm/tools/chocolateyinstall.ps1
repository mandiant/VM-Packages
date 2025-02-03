$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'EvtxECmd'
$category = 'Forensic'
$zipUrl = 'https://download.mikestammer.com/net6/EvtxECmd.zip'

VM-Install-From-Zip $toolName $category $zipUrl -consoleApp $true -innerFolder $true -verifySignature $true
