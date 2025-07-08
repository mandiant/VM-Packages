$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'upx'
$category = VM-Get-Category($MyInvocation.MyCommand.Definition)

$zipUrl = "https://github.com/upx/upx/releases/download/v5.0.1/upx-5.0.1-win32.zip"
$zipSha256 = "2fdc91300631464b9aeefadd65b0c6d57a243cfaaa92ec46496173e76c379e18"
$zipUrl_64 = 'https://github.com/upx/upx/releases/download/v5.0.1/upx-5.0.1-win64.zip'
$zipSha256_64 = 'c288989437ce70646a62799a4dcf25b4ec7ad8fbb4f93a29e25c14856659c1a4'

VM-Install-From-Zip $toolName $category $zipUrl -zipSha256 $zipSha256 -zipUrl_64 $zipUrl_64 -zipSha256_64 $zipSha256_64 -consoleApp $true -innerFolder $true
