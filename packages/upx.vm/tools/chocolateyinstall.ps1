$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'upx'
$category = 'Utilities'

$zipUrl = "https://github.com/upx/upx/releases/download/v4.1.0/upx-4.1.0-win32.zip"
$zipSha256 = "066c62993ce904f9f377ce849e85b77d1e2cf477d554c36c5ff89f6d3f0fa072"
$zipUrl_64 = 'https://github.com/upx/upx/releases/download/v4.1.0/upx-4.1.0-win64.zip'
$zipSha256_64 = '382cee168d6261a76c3b6a98b3ca2de44930bf5faa5f2dc2ced4fa3850fe8ff6'

VM-Install-From-Zip $toolName $category $zipUrl -zipSha256 $zipSha256 -zipUrl_64 $zipUrl_64 -zipSha256_64 $zipSha256_64 -consoleApp $true -innerFolder $true
