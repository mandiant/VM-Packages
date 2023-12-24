$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'Kerbrute'
$category = 'Credential Access'

$exeUrl = 'https://github.com/ropnop/kerbrute/releases/download/v1.0.3/kerbrute_windows_amd64.exe'
$exeSha256 = 'd18aa84b7bf0efde9c6b5db2a38ab1ec9484c59c5284c0bd080f5197bf9388b0'

VM-Install-Single-Exe $toolName $category $exeUrl -exeSha256 $exeSha256 -consoleApp $true
