$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'JumpListExplorer'
$category = VM-Get-Category($MyInvocation.MyCommand.Definition)

$zipUrl = 'https://download.ericzimmermanstools.com/net9/JumpListExplorer.zip'
$zipSha256 = '7c01f2ab828e4a3da3c06f2f3ab904ea2e266f2efd82f7b83ba6c872e95b4f62'

VM-Install-From-Zip $toolName $category $zipUrl -zipSha256 $zipSha256 -consoleApp $false -innerFolder $true
