$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'Bytecode Viewer'
$category = 'Java & Android'

$exeUrl = 'https://github.com/Konloch/bytecode-viewer/releases/download/v2.12/Bytecode-Viewer-2.12.jar'
$exeSha256 = 'dc5f6669409d7d0bbba40c735875a39960c1777f11bb13a1819bb12917808c5c'

VM-Install-Single-Exe $toolName $category $exeUrl -exeSha256 $exeSha256
