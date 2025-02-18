$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'upx'
$category = VM-Get-Category($MyInvocation.MyCommand.Definition)

$zipUrl = "https://github.com/upx/upx/releases/download/v4.2.4/upx-4.2.4-win32.zip"
$zipSha256 = "2e90ebda45b29217126d8e8ee4d0863bd9705a13adcca3ce07b7d19df55ca355"
$zipUrl_64 = 'https://github.com/upx/upx/releases/download/v4.2.4/upx-4.2.4-win64.zip'
$zipSha256_64 = '22e9ef20e4c72aad85e32c71cbc9c086436c179456382aa75c0c24868456a671'

VM-Install-From-Zip $toolName $category $zipUrl -zipSha256 $zipSha256 -zipUrl_64 $zipUrl_64 -zipSha256_64 $zipSha256_64 -consoleApp $true -innerFolder $true
