$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'hayabusa'
$category = VM-Get-Category($MyInvocation.MyCommand.Definition)

$zipUrl = "https://github.com/Yamato-Security/hayabusa/releases/download/v3.2.0/hayabusa-3.2.0-win-x64.zip"
$zipSha256 = '7a9995492ea3479746f5188f48cab4e1f550bc1b7fac981f8b5dfc29576f5328'

$executableName = $toolName.ToLower() + "-3.2.0-win-x64.exe"

VM-Install-From-Zip $toolName $category $zipUrl -zipSha256 $zipSha256 -consoleApp $true -innerFolder $false -executableName $executableName
