$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'recaf-4.0.0'
$category = VM-Get-Category($MyInvocation.MyCommand.Definition)

$exeUrl = 'https://github.com/Col-E/Recaf/releases/download/4.0.0-alpha/recaf-4x-alpha-win-86-x64.jar'
$exeSha256 = 'a3e894306b118ef9a5e6aee4e2ba368c093320a284d933a9975c859243df81eb'

VM-Install-Single-Exe $toolName $category $exeUrl -exeSha256 $exeSha256 -consoleApp $false
