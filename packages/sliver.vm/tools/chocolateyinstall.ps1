$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'Sliver'
$category = 'Command & Control'

$exeUrl = 'https://github.com/BishopFox/sliver/releases/download/v1.5.39/sliver-client_windows.exe'
$exeSha256 = '8b4da3fc66c36752ab032c8d57a0df7caa530d07c3e9847582ff2d792768ff12'

VM-Install-Single-Exe $toolName $category $exeUrl -exeSha256 $exeSha256 -consoleApp $true
