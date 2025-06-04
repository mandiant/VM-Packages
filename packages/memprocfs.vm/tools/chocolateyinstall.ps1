$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'MemProcFS'
$category = VM-Get-Category($MyInvocation.MyCommand.Definition)

$zipUrl = 'https://github.com/ufrisk/MemProcFS/releases/download/v5.14/MemProcFS_files_and_binaries_v5.14.13-win_x64-20250530.zip'
$zipSha256 = '40ce4ac604933dd919444a9cee42431b3fe43813fa4155bef17466b7db03d764'

VM-Install-From-Zip $toolName $category $zipUrl -zipSha256 $zipSha256 -consoleApp $true -innerFolder $false
