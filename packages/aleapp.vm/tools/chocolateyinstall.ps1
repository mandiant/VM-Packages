$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'aleappGUI'
$category = 'Forensic'

$exeUrl = 'https://github.com/abrignoni/ALEAPP/releases/download/v3.2.2/aleappGUI.exe'
$exeSha256 = 'abca427a28765369d6985d68f5503790e551a686cff4c848bc6b3671b8966277'

VM-Install-Single-Exe $toolName -category $category -exeUrl $exeUrl -exeSha256 $exeSha256 -consoleApp $false
