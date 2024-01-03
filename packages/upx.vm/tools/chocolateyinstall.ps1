$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'upx'
$category = 'Packers'

$zipUrl = "https://github.com/upx/upx/releases/download/v4.2.2/upx-4.2.2-win32.zip"
$zipSha256 = "141e7cd8d009b827590662b482f1ae2f1dda17cf446a5651078235efb1429c59"
$zipUrl_64 = 'https://github.com/upx/upx/releases/download/v4.2.2/upx-4.2.2-win64.zip'
$zipSha256_64 = '7c69b92ff2b7fb8122609312eb0a6695c9e4b88a6c784a86c92e3b7ef583281f'

VM-Install-From-Zip $toolName $category $zipUrl -zipSha256 $zipSha256 -zipUrl_64 $zipUrl_64 -zipSha256_64 $zipSha256_64 -consoleApp $true -innerFolder $true
