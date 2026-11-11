$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'hcli'
$category = VM-Get-Category($MyInvocation.MyCommand.Definition)

$exeUrl = 'https://github.com/HexRaysSA/ida-hcli/releases/download/v0.28.0/hcli-windows-x86_64-0.28.0.exe'
$exeSha256 = '8343a52d6fc3c7e9b228d841576efaa63f2bed8bceb0ef8ba7edb24e9f699ba1'

VM-Install-Single-Exe $toolName $category $exeUrl -exeSha256 $exeSha256 -consoleApp $true -arguments '--help'
