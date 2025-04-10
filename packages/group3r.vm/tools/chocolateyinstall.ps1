$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'Group3r'
$category = VM-Get-Category($MyInvocation.MyCommand.Definition)

$exeUrl = 'https://github.com/Group3r/Group3r/releases/download/1.0.69/Group3r.exe'
$exeSha256 = '8f71cf000b5092e214f6e52470b702ce662ad2ed0deff86c26728a0e3532ef25'

VM-Install-Single-Exe $toolName $category $exeUrl -exeSha256 $exeSha256 -consoleApp $true
