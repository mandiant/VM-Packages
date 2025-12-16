$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'Sliver'
$category = VM-Get-Category($MyInvocation.MyCommand.Definition)

$exeUrl = 'https://github.com/BishopFox/sliver/releases/download/v1.5.44/sliver-client_windows.exe'
$exeSha256 = 'c7c7b4ac3bbcb763b7d9c5a0db6e3e4158b690c136df4832cd836809220312a6'

VM-Install-Single-Exe $toolName $category $exeUrl -exeSha256 $exeSha256 -consoleApp $true -arguments "--help"
