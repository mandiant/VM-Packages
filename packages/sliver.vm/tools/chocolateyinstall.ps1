$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'Sliver'
$category = VM-Get-Category($MyInvocation.MyCommand.Definition)

$exeUrl = 'https://github.com/BishopFox/sliver/releases/download/v1.5.43/sliver-client_windows.exe'
$exeSha256 = 'dda342de0a7e948f135ed1d54e1e8149dcc0427fabd6e6e10fe6d5c0d3a65c91'

VM-Install-Single-Exe $toolName $category $exeUrl -exeSha256 $exeSha256 -consoleApp $true -arguments "--help"
