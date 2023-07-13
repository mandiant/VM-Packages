$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'Sliver'
$category = 'Command & Control'

$exeUrl = 'https://github.com/BishopFox/sliver/releases/download/v1.5.41/sliver-client_windows.exe'
$exeSha256 = '85474d2a885a2dbe2dfd334d9d25fbf1079c1d88c857428e2e1cf3e59f2c0a9b'

VM-Install-Single-Exe $toolName $category $exeUrl -exeSha256 $exeSha256 -consoleApp $true
