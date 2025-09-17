$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'hayabusa'
$category = VM-Get-Category($MyInvocation.MyCommand.Definition)

$zipUrl = "https://github.com/Yamato-Security/hayabusa/releases/download/v3.5.0/hayabusa-3.5.0-win-x64.zip"
$zipSha256 = 'dc1959ae78a481e3ad122070538107d9ffd3fba50d7468ce4e7adb4e46430df2'

$executableName = $toolName.ToLower() + "-3.5.0-win-x64.exe"

VM-Install-From-Zip $toolName $category $zipUrl -zipSha256 $zipSha256 -consoleApp $true -innerFolder $false -executableName $executableName
