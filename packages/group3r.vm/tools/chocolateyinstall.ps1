$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'Group3r'
$category = VM-Get-Category($MyInvocation.MyCommand.Definition)

$exeUrl = 'https://github.com/Group3r/Group3r/releases/download/1.0.67/Group3r.exe'
$exeSha256 = '4c3fa4168e5b406f8b4ad0d61e38b85388b04fcaed2abab4c5dc51462d1d515b'

VM-Install-Single-Exe $toolName $category $exeUrl -exeSha256 $exeSha256 -consoleApp $true
