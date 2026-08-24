$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'yara-x'
$category = VM-Get-Category($MyInvocation.MyCommand.Definition)

$zipUrl = 'https://github.com/VirusTotal/yara-x/releases/download/v1.19.0/yara-x-v1.19.0-x86_64-pc-windows-msvc.zip'
$zipSha256 = 'a68d3fcc9cb846a92a1233a6581ee21e777cd5c404d00eebf0628b25900c4f0d'

VM-Install-From-Zip $toolName $category $zipUrl -zipSha256 $zipSha256 -consoleApp $true -executableName 'yr.exe'
