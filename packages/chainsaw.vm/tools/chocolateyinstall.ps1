$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'chainsaw'
$category = VM-Get-Category($MyInvocation.MyCommand.Definition)

$zipUrl = 'https://github.com/WithSecureLabs/chainsaw/releases/download/v2.17.1/chainsaw_all_platforms+rules.zip'
$zipSha256 = '74b9ea341e31c0a704a79c0e779c2f6e31670f1f43cad3b450b21a91639dbec3'

$executableName = $toolName + "_x86_64-pc-windows-msvc.exe"

VM-Install-From-Zip $toolName $category $zipUrl -zipSha256 $zipSha256 -consoleApp $true -innerFolder $true -executableName $executableName
