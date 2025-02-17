$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'Bytecode Viewer'
$category = VM-Get-Category($MyInvocation.MyCommand.Definition)

$exeUrl = 'https://github.com/Konloch/bytecode-viewer/releases/download/v2.13.0/Bytecode-Viewer-2.13.0.jar'
$exeSha256 = 'ea82b3e7ea3149fbe467cbb9a5fd8d69f907ccbe32437fcba577149f9c858960'

VM-Install-Single-Exe $toolName $category $exeUrl -exeSha256 $exeSha256
