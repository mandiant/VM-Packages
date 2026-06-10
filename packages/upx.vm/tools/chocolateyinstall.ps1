$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'upx'
$category = VM-Get-Category($MyInvocation.MyCommand.Definition)

$zipUrl = "https://github.com/upx/upx/releases/download/v5.2.0/upx-5.2.0-win32.zip"
$zipSha256 = "28275e48a8b5ff9719c98a3d6ce68cb4437721f599ca2d904e8f4026a0a0558b"
$zipUrl_64 = 'https://github.com/upx/upx/releases/download/v5.2.0/upx-5.2.0-win64.zip'
$zipSha256_64 = 'b471ebf1b7f20f4a89150264ed9a008a2a5bfd247f3c6d1184a75bb59ca08f5d'

VM-Install-From-Zip $toolName $category $zipUrl -zipSha256 $zipSha256 -zipUrl_64 $zipUrl_64 -zipSha256_64 $zipSha256_64 -consoleApp $true -innerFolder $true
