$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'RegistryExplorer'
$category = VM-Get-Category($MyInvocation.MyCommand.Definition)
$zipUrl = 'https://download.mikestammer.com/net6/RegistryExplorer.zip'

VM-Install-From-Zip $toolName $category $zipUrl -consoleApp $false -innerFolder $true -verifySignature
