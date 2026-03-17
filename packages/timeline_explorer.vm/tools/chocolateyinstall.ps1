$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'TimelineExplorer'
$category = VM-Get-Category($MyInvocation.MyCommand.Definition)

$zipUrl = 'https://download.ericzimmermanstools.com/net9/TimelineExplorer.zip'
$zipSha256 = 'E46799ADACFE2A18C69FAA1E85F084A56C1400832D5FAAF7EFC0A3BDA39D8A9C'

VM-Install-From-Zip $toolName $category $zipUrl -zipSha256 $zipSha256 -consoleApp $false -innerFolder $true
