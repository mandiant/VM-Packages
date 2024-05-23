$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'hayabusa'
$category = 'Forensic'

$zipUrl = "https://github.com/Yamato-Security/hayabusa/releases/download/v2.15.0/hayabusa-2.15.0-win-x64.zip"
$zipSha256 = '158b404fa5fd6937a1331ed1acde262998e6e1586a8604346956d4fc6a14b5d6'

$executableName = $toolName.ToLower() + "-2.15.0-win-x64.exe"

VM-Install-From-Zip $toolName $category $zipUrl -zipSha256 $zipSha256 -consoleApp $true -innerFolder $false -executableName $executableName
