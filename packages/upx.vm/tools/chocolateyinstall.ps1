$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'upx'
$category = 'Packers'

$zipUrl = "https://github.com/upx/upx/releases/download/v4.2.0/upx-4.2.0-win32.zip"
$zipSha256 = "fb1a924136b35e56cd1dbd761dff53fcc9757ccd3210cdbc8ffbd2904dcb66f3"
$zipUrl_64 = 'https://github.com/upx/upx/releases/download/v4.2.0/upx-4.2.0-win64.zip'
$zipSha256_64 = '83833b414d17b39f334de28b981f1a6a88252294b9d76005f2a8047f5c1821f1'

VM-Install-From-Zip $toolName $category $zipUrl -zipSha256 $zipSha256 -zipUrl_64 $zipUrl_64 -zipSha256_64 $zipSha256_64 -consoleApp $true -innerFolder $true
