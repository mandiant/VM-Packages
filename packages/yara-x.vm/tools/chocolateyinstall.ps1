$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'yara-x'
$category = VM-Get-Category($MyInvocation.MyCommand.Definition)

$zipUrl = 'https://github.com/VirusTotal/yara-x/releases/download/v1.23.0/yara-x-v1.23.0-x86_64-pc-windows-msvc.zip'
$zipSha256 = 'b72fd2001c0902981afe9b86ffb152412d904db94e2da9fa626f622b8c5b6a79'

VM-Install-From-Zip $toolName $category $zipUrl -zipSha256 $zipSha256 -consoleApp $true -executableName 'yr.exe'
