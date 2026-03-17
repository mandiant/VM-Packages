$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'VSCMount'
$category = VM-Get-Category($MyInvocation.MyCommand.Definition)

$zipUrl = 'https://download.ericzimmermanstools.com/net9/VSCMount.zip'
$zipSha256 = '6b263ea122a8fe3404a7bff68c7ac316c69f9d9f5c093bf439e06bcea0ffc8b5'

VM-Install-From-Zip $toolName $category $zipUrl -zipSha256 $zipSha256 -consoleApp $true -innerFolder $false
