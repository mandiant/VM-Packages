$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'hcli'
$category = VM-Get-Category($MyInvocation.MyCommand.Definition)

$exeUrl = 'https://github.com/HexRaysSA/ida-hcli/releases/download/v0.29.0/hcli-windows-x86_64-0.29.0.exe'
$exeSha256 = '447090b92192d69647ef63a4c9dc4807027dab6f57d33dcafbc486d204b1228d'

VM-Install-Single-Exe $toolName $category $exeUrl -exeSha256 $exeSha256 -consoleApp $true -arguments '--help'
