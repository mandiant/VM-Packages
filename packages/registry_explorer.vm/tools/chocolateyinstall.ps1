$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'RegistryExplorer'
$category = 'Registry'
$zipUrl = 'https://download.mikestammer.com/net6/RegistryExplorer.zip'

VM-Install-From-Zip $toolName $category $zipUrl -consoleApp $false -innerFolder $true -verifySignature
