$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'hayabusa'
$category = VM-Get-Category($MyInvocation.MyCommand.Definition)

$zipUrl = "https://github.com/Yamato-Security/hayabusa/releases/download/v4.2.0/hayabusa-4.2.0-win-x64.zip"
$zipSha256 = 'e8e49805bf94f5feb425cffae904f526257c1b6bf8dedfa07c28e9aa585a387b'

$executableName = $toolName.ToLower() + "-4.2.0-win-x64.exe"

VM-Install-From-Zip $toolName $category $zipUrl -zipSha256 $zipSha256 -consoleApp $true -innerFolder $false -executableName $executableName
