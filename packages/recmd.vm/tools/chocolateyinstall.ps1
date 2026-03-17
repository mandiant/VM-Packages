$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'RECmd'
$category = VM-Get-Category($MyInvocation.MyCommand.Definition)
$zipUrl = 'https://download.ericzimmermanstools.com/net9/RECmd.zip'

VM-Install-From-Zip $toolName $category $zipUrl -consoleApp $true -innerFolder $true -verifySignature
