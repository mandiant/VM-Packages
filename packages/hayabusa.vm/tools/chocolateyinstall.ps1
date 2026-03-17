$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'hayabusa'
$category = VM-Get-Category($MyInvocation.MyCommand.Definition)

$zipUrl = "https://github.com/Yamato-Security/hayabusa/releases/download/v3.8.1/hayabusa-3.8.1-win-x64.zip"
$zipSha256 = 'bc60ca3667169939abdb44ad740060277fa75c37efd960398414c208ebb334e2'

$executableName = $toolName.ToLower() + "-3.8.1-win-x64.exe"

VM-Install-From-Zip $toolName $category $zipUrl -zipSha256 $zipSha256 -consoleApp $true -innerFolder $false -executableName $executableName
