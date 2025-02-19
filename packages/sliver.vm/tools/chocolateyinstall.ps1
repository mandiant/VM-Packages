$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'Sliver'
$category = VM-Get-Category($MyInvocation.MyCommand.Definition)

$exeUrl = 'https://github.com/BishopFox/sliver/releases/download/v1.5.42/sliver-client_windows.exe'
$exeSha256 = 'b7f9eb0a95f3523aee8363c59e26a88bcf30d2160db862d4d167945ad342d777'

VM-Install-Single-Exe $toolName $category $exeUrl -exeSha256 $exeSha256 -consoleApp $true -arguments "--help"
