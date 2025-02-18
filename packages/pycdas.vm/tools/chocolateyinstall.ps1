$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'pycdas'
$category = VM-Get-Category($MyInvocation.MyCommand.Definition)

$exeUrl = 'https://github.com/extremecoders-re/decompyle-builds/releases/download/build-16-Oct-2024-5e1c403/pycdas.exe'
$exeSha256 = 'b4a2c51ba859282c12ef505419c8897606345e23a97c72612b1ffaf4c12ac72d'

VM-Install-Single-Exe $toolName $category $exeUrl -exeSha256 $exeSha256 -consoleApp $true -arguments "--help"
