$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'Bytecode Viewer'
$category = VM-Get-Category($MyInvocation.MyCommand.Definition)

$exeUrl = 'https://github.com/Konloch/bytecode-viewer/releases/download/v2.13.2/Bytecode-Viewer-2.13.2.jar'
$exeSha256 = '2e23ead17825711bfbf25ffbc6c6af32ca89b057a8e7ccb856cc096ed7f83516'

VM-Install-Single-Exe $toolName $category $exeUrl -exeSha256 $exeSha256
