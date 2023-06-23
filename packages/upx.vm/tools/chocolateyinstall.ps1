$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'upx'
$category = 'Utilities'

$zipUrl = 'https://github.com/upx/upx/releases/download/v4.0.2/upx-4.0.2-win64.zip'
$zipSha256 = '325c58ea2ed375afbd4eeac0b26f15f98db0d75dea701205ca10d8bf4d2fdc24'

VM-Install-From-Zip $toolName $category $zipUrl -zipSha256 $zipSha256 -consoleApp $true -innerFolder $true
