$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'MemProcFS'
$category = VM-Get-Category($MyInvocation.MyCommand.Definition)

$zipUrl = 'https://github.com/ufrisk/MemProcFS/releases/download/v5.15/MemProcFS_files_and_binaries_v5.15.2-win_x64-20250711.zip'
$zipSha256 = '1442a2bcbd206650c2bf818fd9956e0937c44231d11de5b6990a9de678d168bd'

VM-Install-From-Zip $toolName $category $zipUrl -zipSha256 $zipSha256 -consoleApp $true -innerFolder $false
