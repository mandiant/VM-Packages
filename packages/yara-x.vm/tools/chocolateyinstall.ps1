$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'yara-x'
$category = VM-Get-Category($MyInvocation.MyCommand.Definition)

$zipUrl = 'https://github.com/VirusTotal/yara-x/releases/download/v1.22.0/yara-x-v1.22.0-x86_64-pc-windows-msvc.zip'
$zipSha256 = 'eac36a58699b94d3732a7fe1d8453fe89e0077bb18ac2c99b4c2ee102a431f2e'

VM-Install-From-Zip $toolName $category $zipUrl -zipSha256 $zipSha256 -consoleApp $true -executableName 'yr.exe'
