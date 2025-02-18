$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'Cutter'
$category = VM-Get-Category($MyInvocation.MyCommand.Definition)

$zipUrl = 'https://github.com/rizinorg/cutter/releases/download/v2.3.4/Cutter-v2.3.4-Windows-x86_64.zip'
$zipSha256 = '78011f68c2bbfbe4dce057624dbc327b003c412d7db21d7bcdc364a1a67a8f1b'

VM-Install-From-Zip $toolName $category $zipUrl -zipSha256 $zipSha256 -innerFolder $true
