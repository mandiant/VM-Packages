$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'RLA'
$category = VM-Get-Category($MyInvocation.MyCommand.Definition)
$zipUrl = 'https://download.mikestammer.com/net6/rla.zip'

VM-Install-From-Zip $toolName $category $zipUrl -consoleApp $true -innerFolder $false -verifySignature
