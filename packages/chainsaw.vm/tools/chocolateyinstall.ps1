$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'chainsaw'
$category = 'Forensic'

$zipUrl = 'https://github.com/WithSecureLabs/chainsaw/releases/download/v2.8.1/chainsaw_all_platforms+rules.zip'
$zipSha256 = '10969d8f300680b2289808bef43fb254c0689c1052e625ec4cda198b6226d6f1'

$executableName = $toolName + "_x86_64-pc-windows-msvc.exe"

VM-Install-From-Zip $toolName $category $zipUrl -zipSha256 $zipSha256 -consoleApp $true -innerFolder $true -executableName $executableName
