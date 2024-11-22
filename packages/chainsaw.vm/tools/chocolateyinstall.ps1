$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'chainsaw'
$category = 'Forensic'

$zipUrl = 'https://github.com/WithSecureLabs/chainsaw/releases/download/v2.10.1/chainsaw_all_platforms+rules.zip'
$zipSha256 = '767c13000cca26adb23f3f320d2bd3fef78977ea50389658c1d5be941a90881e'

$executableName = $toolName + "_x86_64-pc-windows-msvc.exe"

VM-Install-From-Zip $toolName $category $zipUrl -zipSha256 $zipSha256 -consoleApp $true -innerFolder $true -executableName $executableName
