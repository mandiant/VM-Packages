$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'hayabusa'
$category = 'Forensic'

$zipUrl = "https://github.com/Yamato-Security/hayabusa/releases/download/v2.18.0/hayabusa-2.18.0-win-x64.zip"
$zipSha256 = '2d37b316535b2308ba114949d8054974c290428715326f6bfd657d0ca0389ebe'

$executableName = $toolName.ToLower() + "-2.18.0-win-x64.exe"

VM-Install-From-Zip $toolName $category $zipUrl -zipSha256 $zipSha256 -consoleApp $true -innerFolder $false -executableName $executableName
