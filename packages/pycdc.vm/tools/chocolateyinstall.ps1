$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'pycdc'
$category = VM-Get-Category($MyInvocation.MyCommand.Definition)

$exeUrl = 'https://github.com/extremecoders-re/decompyle-builds/releases/download/build-16-Oct-2024-5e1c403/pycdc.exe'
$exeSha256 = '4dc188d897c0e6054f55c4e3f91ec01ca801ecb674314914d1b0ddfb3529512a'

VM-Install-Single-Exe $toolName $category $exeUrl -exeSha256 $exeSha256 -consoleApp $true -arguments "--help"
