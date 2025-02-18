$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'Group3r'
$category = VM-Get-Category($MyInvocation.MyCommand.Definition)

$exeUrl = 'https://github.com/Group3r/Group3r/releases/download/1.0.65/Group3r.exe'
$exeSha256 = '10accf5038dd9a3353d50e63d208c684ddfe8df4d06b33602fada0f44a739039'

VM-Install-Single-Exe $toolName $category $exeUrl -exeSha256 $exeSha256 -consoleApp $true
