$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'Bytecode Viewer'
$category = VM-Get-Category($MyInvocation.MyCommand.Definition)

$exeUrl = 'https://github.com/Konloch/bytecode-viewer/releases/download/v2.13.1/Bytecode-Viewer-2.13.1.jar'
$exeSha256 = 'f71c457c369e34a9724985ff3b393ccfafeabc3155b87daa1bdbc42635b7fe79'

VM-Install-Single-Exe $toolName $category $exeUrl -exeSha256 $exeSha256
