$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'hayabusa'
$category = VM-Get-Category($MyInvocation.MyCommand.Definition)

$zipUrl = "https://github.com/Yamato-Security/hayabusa/releases/download/v3.9.0/hayabusa-3.9.0-win-x64.zip"
$zipSha256 = 'cf3a1de0e7819dbcef5061632dab25b6dc344d828ba6bfdf6f2ef80ba7299eab'

$executableName = $toolName.ToLower() + "-3.9.0-win-x64.exe"

VM-Install-From-Zip $toolName $category $zipUrl -zipSha256 $zipSha256 -consoleApp $true -innerFolder $false -executableName $executableName
