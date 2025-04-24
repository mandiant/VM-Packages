$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'MemProcFS'
$category = VM-Get-Category($MyInvocation.MyCommand.Definition)

$zipUrl = 'https://github.com/ufrisk/MemProcFS/releases/download/v5.14/MemProcFS_files_and_binaries_v5.14.9-win_x64-20250411.zip'
$zipSha256 = 'ef13fb54fb4a44a1ac758684d3fe473ad91f5c3195f8862de2844860b4bd627d'

VM-Install-From-Zip $toolName $category $zipUrl -zipSha256 $zipSha256 -consoleApp $true -innerFolder $false
