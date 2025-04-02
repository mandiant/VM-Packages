$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'upx'
$category = VM-Get-Category($MyInvocation.MyCommand.Definition)

$zipUrl = "https://github.com/upx/upx/releases/download/v5.0.0/upx-5.0.0-win32.zip"
$zipSha256 = "8c34b9cec2c225bf71f43cf2b788043d0d203d23edb54f649fbec16f34938d80"
$zipUrl_64 = 'https://github.com/upx/upx/releases/download/v5.0.0/upx-5.0.0-win64.zip'
$zipSha256_64 = '1cc4ce7602f42350ea7a960718d4ca8b5c8949ab79b80e709286eff0107b04ea'

VM-Install-From-Zip $toolName $category $zipUrl -zipSha256 $zipSha256 -zipUrl_64 $zipUrl_64 -zipSha256_64 $zipSha256_64 -consoleApp $true -innerFolder $true
