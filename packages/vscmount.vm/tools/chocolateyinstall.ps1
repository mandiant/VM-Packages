$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'VSCMount'
$category = VM-Get-Category($MyInvocation.MyCommand.Definition)

$zipUrl = 'https://download.ericzimmermanstools.com/net9/VSCMount.zip'
$zipSha256 = '6B263EA122A8FE3404A7BFF68C7AC316C69F9D9F5C093BF439E06BCEA0FFC8B5'

VM-Install-From-Zip $toolName $category $zipUrl -zipSha256 $zipSha256 -consoleApp $true -innerFolder $false
