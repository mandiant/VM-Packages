$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'MFTECmd'
$category = VM-Get-Category($MyInvocation.MyCommand.Definition)

$zipUrl = 'https://download.mikestammer.com/net6/MFTECmd.zip'
$zipSha256 = 'c7f20ce740f49a738f7228493f0764a09d23fb1dd67502b7cdd32d73fc3383f3'

VM-Install-From-Zip $toolName $category $zipUrl -zipSha256 $zipSha256 -consoleApp $true -innerFolder $false
