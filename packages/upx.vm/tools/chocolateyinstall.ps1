$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'upx'
$category = 'Utilities'

$zipUrl = "https://github.com/upx/upx/releases/download/v4.0.2/upx-4.0.2-win32.zip"
$zipSha256 = "3f5b59252b0b657143ab945ce10fa0e5c4a509f69588695e11757cb1fc1b7eb7"
$zipUrl_64 = 'https://github.com/upx/upx/releases/download/v4.0.2/upx-4.0.2-win64.zip'
$zipSha256_64 = '325c58ea2ed375afbd4eeac0b26f15f98db0d75dea701205ca10d8bf4d2fdc24'

VM-Install-From-Zip $toolName $category $zipUrl -zipSha256 $zipSha256 -zipUrl_64 $zipUrl_64 -zipSha256_64 $zipSha256_64 -consoleApp $true -innerFolder $true
