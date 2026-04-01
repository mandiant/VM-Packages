$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'binwalk'
$category = VM-Get-Category($MyInvocation.MyCommand.Definition)

$exeUrl = 'https://github.com/emtuls/binwalk/releases/download/v3.1.1/binwalk.exe'
$exeSha256 = '5d2db6e20943c0ab5ecef67057f1df8e75e174ce1f8d5173b3ffe989deede63d'

VM-Install-Single-Exe $toolName $category $exeUrl -exeSha256 $exeSha256 -consoleApp $true
