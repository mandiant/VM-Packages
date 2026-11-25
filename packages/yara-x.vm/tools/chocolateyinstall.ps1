$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'yara-x'
$category = VM-Get-Category($MyInvocation.MyCommand.Definition)

$zipUrl = 'https://github.com/VirusTotal/yara-x/releases/download/v1.24.0/yara-x-v1.24.0-x86_64-pc-windows-msvc.zip'
$zipSha256 = '8b68b49e051b2d2787a74df5588fcf65d41bd21b27689061fd16a80516cb9336'

VM-Install-From-Zip $toolName $category $zipUrl -zipSha256 $zipSha256 -consoleApp $true -executableName 'yr.exe'
