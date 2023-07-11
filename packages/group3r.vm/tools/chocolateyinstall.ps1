$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'Group3r'
$category = 'Reconnaissance'

$exeUrl = 'https://github.com/Group3r/Group3r/releases/download/1.0.53/Group3r.exe'
$exeSha256 = 'a8bb914637ae760a57ab1ea6f00636348371f4bff4ddae20cc14b533ec6d9e6b'

VM-Install-Single-Exe $toolName $category $exeUrl -exeSha256 $exeSha256 -consoleApp $true
