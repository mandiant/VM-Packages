$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'yara-x'
$category = VM-Get-Category($MyInvocation.MyCommand.Definition)

$zipUrl = 'https://github.com/VirusTotal/yara-x/releases/download/v1.21.0/yara-x-v1.21.0-x86_64-pc-windows-msvc.zip'
$zipSha256 = '0e2fc4d2f64df3eaa22129ad5bd074c968a5d80766ddec6183b73175e5c9da25'

VM-Install-From-Zip $toolName $category $zipUrl -zipSha256 $zipSha256 -consoleApp $true -executableName 'yr.exe'
