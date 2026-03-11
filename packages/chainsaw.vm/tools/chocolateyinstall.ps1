$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'chainsaw'
$category = VM-Get-Category($MyInvocation.MyCommand.Definition)

$zipUrl = 'https://github.com/WithSecureLabs/chainsaw/releases/download/v2.14.1/chainsaw_all_platforms+rules.zip'
$zipSha256 = 'c97c734bfa4d3df08e9585173d101f7cf668e4dc1e182b4a9dfa6d53226e4272'

$executableName = $toolName + "_x86_64-pc-windows-msvc.exe"

VM-Install-From-Zip $toolName $category $zipUrl -zipSha256 $zipSha256 -consoleApp $true -innerFolder $true -executableName $executableName
