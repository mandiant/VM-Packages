$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'Group3r'
$category = 'Reconnaissance'

$exeUrl = 'https://github.com/Group3r/Group3r/releases/download/1.0.59/Group3r.exe'
$exeSha256 = '427a990d8ee64c640faa8e1be48637ef64ec300615686d4bf212503c7926e2d4'

VM-Install-Single-Exe $toolName $category $exeUrl -exeSha256 $exeSha256 -consoleApp $true
