$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'hayabusa'
$category = VM-Get-Category($MyInvocation.MyCommand.Definition)

$zipUrl = "https://github.com/Yamato-Security/hayabusa/releases/download/v4.0.0/hayabusa-4.0.0-win-x64.zip"
$zipSha256 = '6e173c9fd1fa8ee4d95931ea1e1997723330c4779f4f83a96dcd3f1b00d31ff5'

$executableName = $toolName.ToLower() + "-4.0.0-win-x64.exe"

VM-Install-From-Zip $toolName $category $zipUrl -zipSha256 $zipSha256 -consoleApp $true -innerFolder $false -executableName $executableName
