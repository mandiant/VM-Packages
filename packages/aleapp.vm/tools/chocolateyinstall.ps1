$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'aleappGUI'
$category = 'Forensic'

$exeUrl = 'https://github.com/abrignoni/ALEAPP/releases/download/v3.1.9/aleappGUI.exe'
$exeSha256 = 'a5a516bfab416e78b951a8175347916c6c362325d6616c4029af164f420cf5a4'

VM-Install-Single-Exe $toolName -category $category -exeUrl $exeUrl -exeSha256 $exeSha256 -consoleApp $false
