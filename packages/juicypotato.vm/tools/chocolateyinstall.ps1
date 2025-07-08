$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'JuicyPotato'
$category = VM-Get-Category($MyInvocation.MyCommand.Definition)

$exeUrl = 'https://github.com/ohpe/juicy-potato/releases/download/v0.1/JuicyPotato.exe'
$exeSha256 = '0f56c703e9b7ddeb90646927bac05a5c6d95308c8e13b88e5d4f4b572423e036'

VM-Install-Single-Exe $toolName $category $exeUrl -exeSha256 $exeSha256 -consoleApp $true
