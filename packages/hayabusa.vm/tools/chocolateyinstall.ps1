$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'hayabusa'
$category = VM-Get-Category($MyInvocation.MyCommand.Definition)

$zipUrl = "https://github.com/Yamato-Security/hayabusa/releases/download/v3.4.0/hayabusa-3.4.0-win-x64.zip"
$zipSha256 = '1261c0f4fba508533f8b55912dc37869c07106b16a1d62c7b5eaf1feaec26690'

$executableName = $toolName.ToLower() + "-3.4.0-win-x64.exe"

VM-Install-From-Zip $toolName $category $zipUrl -zipSha256 $zipSha256 -consoleApp $true -innerFolder $false -executableName $executableName
