$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'SharpClipHistory'
$category = 'Credential Access'

$exeUrl = 'https://github.com/FSecureLABS/SharpClipHistory/releases/download/v1.0/SharpClipHistory.exe'
$exeSha256 = '4527b53e515c275e572f307246614ba4fc9152a25dfd2fd712246b321626bac6'

VM-Install-Single-Exe $toolName $category $exeUrl -exeSha256 $exeSha256 -consoleApp $true
