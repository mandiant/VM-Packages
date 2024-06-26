$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'hayabusa'
$category = 'Forensic'

$zipUrl = "https://github.com/Yamato-Security/hayabusa/releases/download/v2.16.0/hayabusa-2.16.0-win-x64.zip"
$zipSha256 = '38049502fc482ca83a1a08b050619b55416abc8bb378db10da40b4a47b659389'

$executableName = $toolName.ToLower() + "-2.16.0-win-x64.exe"

VM-Install-From-Zip $toolName $category $zipUrl -zipSha256 $zipSha256 -consoleApp $true -innerFolder $false -executableName $executableName
