$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'Cutter'
$category = VM-Get-Category($MyInvocation.MyCommand.Definition)

$zipUrl = 'https://github.com/rizinorg/cutter/releases/download/v2.4.0/Cutter-v2.4.0-Windows-x86_64.zip'
$zipSha256 = '82a50db471a9d5f5e96187769b5ca04a7a7d2f7c5597a25087780c57abc62c95'

VM-Install-From-Zip $toolName $category $zipUrl -zipSha256 $zipSha256 -innerFolder $true
