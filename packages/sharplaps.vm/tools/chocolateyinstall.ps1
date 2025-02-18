$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'SharpLAPS'
$category = VM-Get-Category($MyInvocation.MyCommand.Definition)

$exeUrl = 'https://github.com/swisskyrepo/SharpLAPS/releases/download/latest-SharpLAPS/SharpLAPS.exe'
$exeSha256 = 'ef0d508b3051fe6f99ba55202a17237f29fdbc0085e3f5c99b1aef52c8ebe425'

VM-Install-Single-Exe $toolName $category $exeUrl -exeSha256 $exeSha256 -consoleApp $true
