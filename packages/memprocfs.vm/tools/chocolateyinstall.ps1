$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'MemProcFS'
$category = VM-Get-Category($MyInvocation.MyCommand.Definition)

$zipUrl = 'https://github.com/ufrisk/MemProcFS/releases/download/v5.17/MemProcFS_files_and_binaries_v5.17.4-win_x64-20260325.zip'
$zipSha256 = '7d6fc13e1c77e05e9707f2cbfa0c20c6e50271e8dfcc1881bd6e6916a164b9be'

VM-Install-From-Zip $toolName $category $zipUrl -zipSha256 $zipSha256 -consoleApp $true -innerFolder $false
