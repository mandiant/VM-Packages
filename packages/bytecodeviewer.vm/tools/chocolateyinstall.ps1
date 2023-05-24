$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'Bytecode Viewer'
$category = 'Java/Android'

$exeUrl = 'https://github.com/Konloch/bytecode-viewer/releases/download/v2.11.2/Bytecode-Viewer-2.11.2.jar'
$exeSha256 = '536ad387424106083f76cd0cb7c051a22aff21f08663ba2539c11f1ddef9147f'

VM-Install-Single-Exe $toolName $category $exeUrl -exeSha256 $exeSha256
