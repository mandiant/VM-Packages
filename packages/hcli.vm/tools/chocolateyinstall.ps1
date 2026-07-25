$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'hcli'
$category = VM-Get-Category($MyInvocation.MyCommand.Definition)

$exeUrl = 'https://github.com/HexRaysSA/ida-hcli/releases/download/v0.18.5/hcli-windows-x86_64-0.18.5.exe'
$exeSha256 = 'be99bfcb9edd176e59200e6ae3df755269de2925ea53f0e48664fd67fcf28ca5'

VM-Install-Single-Exe $toolName $category $exeUrl -exeSha256 $exeSha256 -consoleApp $true -arguments '--help'
