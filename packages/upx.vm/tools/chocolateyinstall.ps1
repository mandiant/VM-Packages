$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'upx'
$category = VM-Get-Category($MyInvocation.MyCommand.Definition)

$zipUrl = "https://github.com/upx/upx/releases/download/v5.1.1/upx-5.1.1-win32.zip"
$zipSha256 = "c0fc8553784ad64145c37a6379f7aa2daf143580437792e862ba6f4630e9f0da"
$zipUrl_64 = 'https://github.com/upx/upx/releases/download/v5.1.1/upx-5.1.1-win64.zip'
$zipSha256_64 = 'fa5380bca4c2718547aaa0134bc0d8a7fa27e102f0ac6371573d60d1c21d64de'

VM-Install-From-Zip $toolName $category $zipUrl -zipSha256 $zipSha256 -zipUrl_64 $zipUrl_64 -zipSha256_64 $zipSha256_64 -consoleApp $true -innerFolder $true
