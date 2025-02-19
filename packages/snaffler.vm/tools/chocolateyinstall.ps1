$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'Snaffler'
$category = VM-Get-Category($MyInvocation.MyCommand.Definition)

$exeUrl = 'https://github.com/SnaffCon/Snaffler/releases/download/1.0.184/Snaffler.exe'
$exeSha256 = 'a9c3b97f77c2908b9c9f3c4f46a3c58217da3f3bb6fb9bbaeed59560a493d49b'

VM-Install-Single-Exe $toolName $category $exeUrl -exeSha256 $exeSha256 -consoleApp $true
