$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'upx'
$category = VM-Get-Category($MyInvocation.MyCommand.Definition)

$zipUrl = "https://github.com/upx/upx/releases/download/v5.3.0/upx-5.3.0-win32.zip"
$zipSha256 = "36a740f077637d66da90a133a2a166e90dd692be5d08b2350fec97ed23809d53"
$zipUrl_64 = 'https://github.com/upx/upx/releases/download/v5.3.0/upx-5.3.0-win64.zip'
$zipSha256_64 = 'd127996c76615e431be810e9c8d2910dbe3dd400600c5c0c50276fc5a17a9705'

VM-Install-From-Zip $toolName $category $zipUrl -zipSha256 $zipSha256 -zipUrl_64 $zipUrl_64 -zipSha256_64 $zipSha256_64 -consoleApp $true -innerFolder $true
