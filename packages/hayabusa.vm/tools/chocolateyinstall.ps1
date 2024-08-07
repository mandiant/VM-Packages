$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'hayabusa'
$category = 'Forensic'

$zipUrl = "https://github.com/Yamato-Security/hayabusa/releases/download/v2.16.1/hayabusa-2.16.1-win-x64.zip"
$zipSha256 = '1c80c573a9e4f762646910fd5d5c78f7aa1790c1b9ce1510de3bb15893aff52b'

$executableName = $toolName.ToLower() + "-2.16.1-win-x64.exe"

VM-Install-From-Zip $toolName $category $zipUrl -zipSha256 $zipSha256 -consoleApp $true -innerFolder $false -executableName $executableName
