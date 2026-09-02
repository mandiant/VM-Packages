$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'yara-x'
$category = VM-Get-Category($MyInvocation.MyCommand.Definition)

$zipUrl = 'https://github.com/VirusTotal/yara-x/releases/download/v1.20.0/yara-x-v1.20.0-x86_64-pc-windows-msvc.zip'
$zipSha256 = 'b1e2840bac593aea353d2b2b341f5a862c9d61c0c406d9abbbad9e1fa35163a1'

VM-Install-From-Zip $toolName $category $zipUrl -zipSha256 $zipSha256 -consoleApp $true -executableName 'yr.exe'
