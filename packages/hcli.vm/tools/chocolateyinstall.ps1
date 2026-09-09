$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'hcli'
$category = VM-Get-Category($MyInvocation.MyCommand.Definition)

$exeUrl = 'https://github.com/HexRaysSA/ida-hcli/releases/download/v0.22.0/hcli-windows-x86_64-0.22.0.exe'
$exeSha256 = '7d5253cd4ce729b148230bd985abb2e77a17b23e1fcbed48e0bd348c6b2823c4'

VM-Install-Single-Exe $toolName $category $exeUrl -exeSha256 $exeSha256 -consoleApp $true -arguments '--help'
