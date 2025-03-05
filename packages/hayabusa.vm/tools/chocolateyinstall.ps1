$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'hayabusa'
$category = VM-Get-Category($MyInvocation.MyCommand.Definition)

$zipUrl = "https://github.com/Yamato-Security/hayabusa/releases/download/v3.1.0/hayabusa-3.1.0-win-x64.zip"
$zipSha256 = '75f55aa79ea7b395196f94cf38eae04eeca645286ae227657689c29075b53c57'

$executableName = $toolName.ToLower() + "-3.1.0-win-x64.exe"

VM-Install-From-Zip $toolName $category $zipUrl -zipSha256 $zipSha256 -consoleApp $true -innerFolder $false -executableName $executableName
