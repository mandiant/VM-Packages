$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'upx'
$category = VM-Get-Category($MyInvocation.MyCommand.Definition)

$zipUrl = "https://github.com/upx/upx/releases/download/v5.1.0/upx-5.1.0-win32.zip"
$zipSha256 = "9a0d3dcbcfd56ef1a5fa922af0978d445cc1a4ec25609639ccb8db369a49be03"
$zipUrl_64 = 'https://github.com/upx/upx/releases/download/v5.1.0/upx-5.1.0-win64.zip'
$zipSha256_64 = '41c7492edeed0f7e67d347ca9e8d2131e2af7ca7a7695f92283a8e655c251c13'

VM-Install-From-Zip $toolName $category $zipUrl -zipSha256 $zipSha256 -zipUrl_64 $zipUrl_64 -zipSha256_64 $zipSha256_64 -consoleApp $true -innerFolder $true
