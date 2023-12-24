$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'hayabusa'
$category = 'Forensic'

$version = '2.11.0'
$zipUrl = "https://github.com/Yamato-Security/hayabusa/releases/download/v$version/hayabusa-$version-win-64-bit.zip"
$zipSha256 = '79847e15f14f8bda738f3b6dbca03bd2b742f09f11c129b75941fe6f3ec8c164'

$executableName = $toolName.ToLower() + "-$version-win-x64.exe"

VM-Install-From-Zip $toolName $category $zipUrl -zipSha256 $zipSha256 -consoleApp $true -innerFolder $false -executableName $executableName
