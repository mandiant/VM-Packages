$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'MemProcFS'
$category = VM-Get-Category($MyInvocation.MyCommand.Definition)

$zipUrl = 'https://github.com/ufrisk/MemProcFS/releases/download/v5.14.13/MemProcFS_files_and_binaries_v5.14.9-win_x64-20250411.zip'
$zipSha256 = '53036def133480a1d68bc5d9cbd74fc03125b508c5a98910a5dd9c8bec43f722'

VM-Install-From-Zip $toolName $category $zipUrl -zipSha256 $zipSha256 -consoleApp $true -innerFolder $false

