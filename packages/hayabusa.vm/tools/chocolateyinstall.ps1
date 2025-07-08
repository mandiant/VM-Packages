$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'hayabusa'
$category = VM-Get-Category($MyInvocation.MyCommand.Definition)

$zipUrl = "https://github.com/Yamato-Security/hayabusa/releases/download/v3.3.0/hayabusa-3.3.0-win-x64.zip"
$zipSha256 = '37bee154170429d272f3c5b228957d62c116d44cd52e6d3fb24e4b49785d6bbd'

$executableName = $toolName.ToLower() + "-3.3.0-win-x64.exe"

VM-Install-From-Zip $toolName $category $zipUrl -zipSha256 $zipSha256 -consoleApp $true -innerFolder $false -executableName $executableName
