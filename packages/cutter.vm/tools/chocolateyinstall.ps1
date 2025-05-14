$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'Cutter'
$category = VM-Get-Category($MyInvocation.MyCommand.Definition)

$zipUrl = 'https://github.com/rizinorg/cutter/releases/download/v2.4.1/Cutter-v2.4.1-Windows-x86_64.zip'
$zipSha256 = '7156882b79870355f25fb273f36a313b71e0e76cd97e5a5765db4d163da39175'

VM-Install-From-Zip $toolName $category $zipUrl -zipSha256 $zipSha256 -innerFolder $true
