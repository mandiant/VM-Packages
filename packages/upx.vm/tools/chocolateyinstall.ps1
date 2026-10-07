$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'upx'
$category = VM-Get-Category($MyInvocation.MyCommand.Definition)

$zipUrl = "https://github.com/upx/upx/releases/download/v5.2.1/upx-5.2.1-win32.zip"
$zipSha256 = "4a06f247b0184976c1e7fd5af9293977cdb1bf4ba9416ae58e3560bd62d871ff"
$zipUrl_64 = 'https://github.com/upx/upx/releases/download/v5.2.1/upx-5.2.1-win64.zip'
$zipSha256_64 = 'eabc6792a347d45e945be7748423e7868fd01b0d2bcaa2f4b1031fd71ff69bda'

VM-Install-From-Zip $toolName $category $zipUrl -zipSha256 $zipSha256 -zipUrl_64 $zipUrl_64 -zipSha256_64 $zipSha256_64 -consoleApp $true -innerFolder $true
