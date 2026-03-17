$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'PECmd'
$category = VM-Get-Category($MyInvocation.MyCommand.Definition)

$zipUrl = 'https://download.ericzimmermanstools.com/net9/PECmd.zip'
$zipSha256 = 'F34E30E53A7B0E05F3418E92C8CA1301CEE762BA4CEA8F382E74ACFFE68D7E1B'

VM-Install-From-Zip $toolName $category $zipUrl -zipSha256 $zipSha256 -consoleApp $true -innerFolder $false -verifySignature
