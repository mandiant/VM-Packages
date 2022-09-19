$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'Bytecode Viewer'
$category = 'Java'

$zipUrl = 'https://github.com/Konloch/bytecode-viewer/releases/download/v2.11.2/Bytecode-Viewer-2.11.2.jar'
$zipSha256 = '536ad387424106083f76cd0cb7c051a22aff21f08663ba2539c11f1ddef9147f'

VM-Install-From-Zip $toolName $category $zipUrl -zipSha256 $zipSha256
