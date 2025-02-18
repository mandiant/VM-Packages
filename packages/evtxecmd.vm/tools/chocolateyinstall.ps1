$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'EvtxECmd'
$category = VM-Get-Category($MyInvocation.MyCommand.Definition)
$zipUrl = 'https://download.mikestammer.com/net6/EvtxECmd.zip'

VM-Install-From-Zip $toolName $category $zipUrl -consoleApp $true -innerFolder $true -verifySignature
