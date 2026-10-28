$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'yara-x'
$category = VM-Get-Category($MyInvocation.MyCommand.Definition)

$zipUrl = 'https://github.com/VirusTotal/yara-x/releases/download/v1.22.1/yara-x-v1.22.1-x86_64-pc-windows-msvc.zip'
$zipSha256 = 'dbe8c1ec5d59d8a81c777d949c518fb5e75f1026d3419bca7817727c5d47b327'

VM-Install-From-Zip $toolName $category $zipUrl -zipSha256 $zipSha256 -consoleApp $true -executableName 'yr.exe'
