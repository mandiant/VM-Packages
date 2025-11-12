$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'Snaffler'
$category = VM-Get-Category($MyInvocation.MyCommand.Definition)

$exeUrl = 'https://github.com/SnaffCon/Snaffler/releases/download/1.0.224/Snaffler.exe'
$exeSha256 = '35295339012ed75ed619c51c3c4d3e8d72b32bf643518a9982f6b614a6afed1e'

VM-Install-Single-Exe $toolName $category $exeUrl -exeSha256 $exeSha256 -consoleApp $true
