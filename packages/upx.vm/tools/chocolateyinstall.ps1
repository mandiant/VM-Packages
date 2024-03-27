$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'upx'
$category = 'Packers'

$zipUrl = "https://github.com/upx/upx/releases/download/v4.2.3/upx-4.2.3-win32.zip"
$zipSha256 = "46063a5e41b56b137f14ffc8f30f7502c155a60cd959595727f5d02a2bffa997"
$zipUrl_64 = 'https://github.com/upx/upx/releases/download/v4.2.3/upx-4.2.3-win64.zip'
$zipSha256_64 = '5f0458eb44ef2a9f8a3d02946e2d1382b1dac3e4a95d4dacf662ede567abfc59'

VM-Install-From-Zip $toolName $category $zipUrl -zipSha256 $zipSha256 -zipUrl_64 $zipUrl_64 -zipSha256_64 $zipSha256_64 -consoleApp $true -innerFolder $true
