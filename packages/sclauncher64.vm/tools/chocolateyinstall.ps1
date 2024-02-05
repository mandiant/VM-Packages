$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'SCLauncher64'
$category = 'Utilities'

$exeUrl = 'https://github.com/jstrosch/sclauncher/releases/download/v0.0.3/sclauncher64.exe'
$exeSha256 = '0887c4b93ec9595f69a5d38596553d91a29cac4a299d68f3030127778c614da0'

VM-Install-Single-Exe $toolName $category $exeUrl -exeSha256 $exeSha256 -consoleApp $true
