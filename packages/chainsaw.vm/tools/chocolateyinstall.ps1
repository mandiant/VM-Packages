$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'chainsaw'
$category = VM-Get-Category($MyInvocation.MyCommand.Definition)

$zipUrl = 'https://github.com/WithSecureLabs/chainsaw/releases/download/v2.12.2/chainsaw_all_platforms+rules.zip'
$zipSha256 = '23435fd706f1462397cc67721a8b01f16276b14cb1280ff97d4014f533be847e'

$executableName = $toolName + "_x86_64-pc-windows-msvc.exe"

VM-Install-From-Zip $toolName $category $zipUrl -zipSha256 $zipSha256 -consoleApp $true -innerFolder $true -executableName $executableName
