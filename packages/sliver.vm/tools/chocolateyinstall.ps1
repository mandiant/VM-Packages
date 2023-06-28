$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'Sliver'
$category = 'Command & Control'

$exeUrl = 'https://github.com/BishopFox/sliver/releases/download/v1.5.40/sliver-client_windows.exe'
$exeSha256 = '48359bfb6692ea45f075188b2b244fc8fcec4ef7e80d2c2eecae90d5c9cdd04b'

VM-Install-Single-Exe $toolName $category $exeUrl -exeSha256 $exeSha256 -consoleApp $true
