$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'MemProcFS'
$category = 'Forensic'

$zipUrl = 'https://github.com/ufrisk/MemProcFS/releases/download/v5_archive/MemProcFS_files_and_binaries_v5.8.17-win_x64-20231128.zip'
$zipSha256 = '22196c8fdd09db229ed8ee649e56b406a5f8dd43f7728cfe13cd1618aaef7085'

VM-Install-From-Zip $toolName $category $zipUrl -zipSha256 $zipSha256 -consoleApp $true -innerFolder $false
