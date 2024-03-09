$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'MemProcFS'
$category = 'Forensic'

$zipUrl = 'https://github.com/ufrisk/MemProcFS/releases/download/v5_archive/MemProcFS_files_and_binaries_v5.9.4-win_x64-20240318.zip'
$zipSha256 = 'd63b2e3ee2b67abf9e119bd912bb2e595ddba96abf4f8b19255157c889c516ac'

VM-Install-From-Zip $toolName $category $zipUrl -zipSha256 $zipSha256 -consoleApp $true -innerFolder $false
