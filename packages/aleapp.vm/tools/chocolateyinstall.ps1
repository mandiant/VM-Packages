$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'aleappGUI'
$category = 'Forensic'

$exeUrl = 'https://github.com/abrignoni/ALEAPP/releases/download/v3.2.1/aleappGUI.exe'
$exeSha256 = '39d7a90c74ec49dbbc18051ae70798972f0934c9c1f6f97cf8c0c6cd701c665a'

VM-Install-Single-Exe $toolName -category $category -exeUrl $exeUrl -exeSha256 $exeSha256 -consoleApp $false
