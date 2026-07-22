$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'hayabusa'
$category = VM-Get-Category($MyInvocation.MyCommand.Definition)

$zipUrl = "https://github.com/Yamato-Security/hayabusa/releases/download/v3.10.0/hayabusa-3.10.0-win-x64.zip"
$zipSha256 = '8dd2b2d124ce3f96d2fe63cd7a0ea4c54ad2984d820324c3388ec30f9c6b8209'

$executableName = $toolName.ToLower() + "-3.10.0-win-x64.exe"

VM-Install-From-Zip $toolName $category $zipUrl -zipSha256 $zipSha256 -consoleApp $true -innerFolder $false -executableName $executableName
