$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'hayabusa'
$category = VM-Get-Category($MyInvocation.MyCommand.Definition)

$zipUrl = "https://github.com/Yamato-Security/hayabusa/releases/download/v4.1.0/hayabusa-4.1.0-win-x64.zip"
$zipSha256 = '4d304cc5baaa750ed08cc24b7b89c58ea058740c7e344502d7b82554637543a8'

$executableName = $toolName.ToLower() + "-4.1.0-win-x64.exe"

VM-Install-From-Zip $toolName $category $zipUrl -zipSha256 $zipSha256 -consoleApp $true -innerFolder $false -executableName $executableName
