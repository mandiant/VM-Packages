$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'upx'
$category = 'Packers'

$zipUrl = "https://github.com/upx/upx/releases/download/v4.2.1/upx-4.2.1-win32.zip"
$zipSha256 = "475504d9b2ae5fd9ede27919ee3b3fa8869a1398645c1239fc19193022054268"
$zipUrl_64 = 'https://github.com/upx/upx/releases/download/v4.2.1/upx-4.2.1-win64.zip'
$zipSha256_64 = 'b6e20e35303a390c3b1211f5ed0559def2c34ec5774176bb22afee19b35b2138'

VM-Install-From-Zip $toolName $category $zipUrl -zipSha256 $zipSha256 -zipUrl_64 $zipUrl_64 -zipSha256_64 $zipSha256_64 -consoleApp $true -innerFolder $true
