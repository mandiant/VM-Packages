$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'hayabusa'
$category = 'Forensic'

$zipUrl = "https://github.com/Yamato-Security/hayabusa/releases/download/v2.17.0/hayabusa-2.17.0-win-x64.zip"
$zipSha256 = '7ad371b4f567af590edcd3740a939f738aebb56ac1481c1036a031aa46aace28'

$executableName = $toolName.ToLower() + "-2.17.0-win-x64.exe"

VM-Install-From-Zip $toolName $category $zipUrl -zipSha256 $zipSha256 -consoleApp $true -innerFolder $false -executableName $executableName
