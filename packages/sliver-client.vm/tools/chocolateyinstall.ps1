$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'Sliver-Client'
$category = 'Command & Control'

$exeUrl = 'https://github.com/BishopFox/sliver/releases/download/v1.5.38/sliver-client_windows.exe'
$exeSha256 = 'ad1117e7a6d3284f9ddc7f8ec841f72b759932d1467cffd9633af242f8f00798'

VM-Install-Single-Exe $toolName $category $exeUrl -exeSha256 $exeSha256
