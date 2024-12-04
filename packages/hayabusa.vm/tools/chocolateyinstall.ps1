$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'hayabusa'
$category = 'Forensic'

$zipUrl = "https://github.com/Yamato-Security/hayabusa/releases/download/v2.19.0/hayabusa-2.19.0-win-x64.zip"
$zipSha256 = 'cfac8c98aae65b1508fd4f922292962a50b8478a5f9958e22258d3512adacc5b'

$executableName = $toolName.ToLower() + "-2.19.0-win-x64.exe"

VM-Install-From-Zip $toolName $category $zipUrl -zipSha256 $zipSha256 -consoleApp $true -innerFolder $false -executableName $executableName
