$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'RLA'
$category = 'Forensic'
$zipUrl = 'https://download.mikestammer.com/net6/rla.zip'

VM-Install-From-Zip $toolName $category $zipUrl -consoleApp $true -innerFolder $false -verifySignature
