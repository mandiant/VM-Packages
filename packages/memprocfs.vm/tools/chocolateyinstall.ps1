$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'MemProcFS'
$category = VM-Get-Category($MyInvocation.MyCommand.Definition)

$zipUrl = 'https://github.com/ufrisk/MemProcFS/releases/download/v5.14/MemProcFS_files_and_binaries_v5.14.13-win_x64-20250520.zip'
$zipSha256 = 'be8845d5f1aae729ebfeb85d9b66cd06fa2c6894e427e1c77d9cf603b16ac805'

VM-Install-From-Zip $toolName $category $zipUrl -zipSha256 $zipSha256 -consoleApp $true -innerFolder $false
