$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'reg_export'
$category = 'Registry'

$exeUrl = 'https://github.com/adamkramer/reg_export/releases/download/v1.3/reg_export.exe'
$exeSha256 = '0786cf26a63a059986fa7c568c1833825104e52565c17ff777f45d3118a8b274'

VM-Install-Single-Exe $toolName $category $exeUrl -exeSha256 $exeSha256 -consoleApp $true
