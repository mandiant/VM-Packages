$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'hcli'
$category = VM-Get-Category($MyInvocation.MyCommand.Definition)

$exeUrl = 'https://github.com/HexRaysSA/ida-hcli/releases/download/v0.19.0/hcli-windows-x86_64-0.19.0.exe'
$exeSha256 = 'b377daa89def52e5db6814cebbb56308312a75e0912f8ee022065a4bc37a2f2d'

VM-Install-Single-Exe $toolName $category $exeUrl -exeSha256 $exeSha256 -consoleApp $true -arguments '--help'
