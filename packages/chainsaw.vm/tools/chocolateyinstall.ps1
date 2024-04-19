$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'chainsaw'
$category = 'Forensic'

$zipUrl = 'https://github.com/WithSecureLabs/chainsaw/releases/download/v2.9.0/chainsaw_all_platforms+rules.zip'
$zipSha256 = 'a48330a6c8c5905bf5f6e74fa01cb7ed87d36d1e799d6614c49f3e1ecdc44f41'

$executableName = $toolName + "_x86_64-pc-windows-msvc.exe"

VM-Install-From-Zip $toolName $category $zipUrl -zipSha256 $zipSha256 -consoleApp $true -innerFolder $true -executableName $executableName
