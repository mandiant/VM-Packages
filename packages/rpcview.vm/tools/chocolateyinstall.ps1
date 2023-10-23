$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'RpcView'
$category = 'Utilities'

$zipUrl = 'https://github.com/silverf0x/RpcView/releases/download/v0.3.1.90/RpcView64.7z'
$zipSha256 = 'a1d89c9d81a2e9c7558e8f0c91ec8652d40af94726f3125f9fe31206adb528de'

VM-Install-From-Zip $toolName $category $zipUrl -zipSha256 $zipSha256 -consoleApp $false -innerFolder $true
