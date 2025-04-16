$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'Snaffler'
$category = VM-Get-Category($MyInvocation.MyCommand.Definition)

$exeUrl = 'https://github.com/SnaffCon/Snaffler/releases/download/1.0.198/Snaffler.exe'
$exeSha256 = '4fa84020ab254ebcfe7111dcb1761be51561d578c9a0c00b113546a2c9d28075'

VM-Install-Single-Exe $toolName $category $exeUrl -exeSha256 $exeSha256 -consoleApp $true
