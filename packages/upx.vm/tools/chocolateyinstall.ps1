$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'upx'
$category = VM-Get-Category($MyInvocation.MyCommand.Definition)

$zipUrl = "https://github.com/upx/upx/releases/download/v5.0.2/upx-5.0.2-win32.zip"
$zipSha256 = "61b3c81e5ad2c2f4d7061054fb7ddcb73400ba4f2dae79255153ccfd77523400"
$zipUrl_64 = 'https://github.com/upx/upx/releases/download/v5.0.2/upx-5.0.2-win64.zip'
$zipSha256_64 = '1cff6d6ee01c404d4a1ae56003056bd4cfa28d0a5cea1d0950daaf872a4facc9'

VM-Install-From-Zip $toolName $category $zipUrl -zipSha256 $zipSha256 -zipUrl_64 $zipUrl_64 -zipSha256_64 $zipSha256_64 -consoleApp $true -innerFolder $true
