$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'recaf-4.0.0'
$category = VM-Get-Category($MyInvocation.MyCommand.Definition)

$exeUrl = 'https://github.com/Col-E/Recaf/releases/download/4.0.0-alpha/recaf-4x-alpha-win-86x64.jar'
$exeSha256 = '5a4b960521b4008f44f5c887376da55d4c9b2025b80e53b7a8fcc124947e411a'

VM-Install-Single-Exe $toolName $category $exeUrl -exeSha256 $exeSha256 -consoleApp $false
