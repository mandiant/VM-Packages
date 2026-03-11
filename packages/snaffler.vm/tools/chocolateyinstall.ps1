$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'Snaffler'
$category = VM-Get-Category($MyInvocation.MyCommand.Definition)

$exeUrl = 'https://github.com/SnaffCon/Snaffler/releases/download/1.0.244/Snaffler.exe'
$exeSha256 = '397b22a956545ba9cd5f03f0f61cb16e4760db21be97f979a5cfc059c2f854ca'

VM-Install-Single-Exe $toolName $category $exeUrl -exeSha256 $exeSha256 -consoleApp $true
