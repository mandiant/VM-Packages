$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'MemProcFS'
$category = VM-Get-Category($MyInvocation.MyCommand.Definition)

$zipUrl = 'https://github.com/ufrisk/MemProcFS/releases/download/v5.16/MemProcFS_files_and_binaries_v5.16.8-win_x64-20251211.zip'
$zipSha256 = 'ecd431ae214df1cc7eb3c6987f4673ce1ad9742cbd96a1dd9ce8ee7aae48a690'

VM-Install-From-Zip $toolName $category $zipUrl -zipSha256 $zipSha256 -consoleApp $true -innerFolder $false
