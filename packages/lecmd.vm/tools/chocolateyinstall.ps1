$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'LECmd'
$category = 'Forensic'

$zipUrl = 'https://download.mikestammer.com/net6/LECmd.zip'
$zipSha256 = '545f6eb250fa44c1d0c8f0abe361e283c3f22194f32dbae8e913265cefb05677'

VM-Install-From-Zip $toolName $category $zipUrl -zipSha256 $zipSha256 -consoleApp $true -innerFolder $false
