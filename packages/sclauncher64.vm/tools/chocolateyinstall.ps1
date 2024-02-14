$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'SCLauncher64'
$category = 'Utilities'

$exeUrl = 'https://github.com/jstrosch/sclauncher/releases/download/v0.0.4/sclauncher64.exe'
$exeSha256 = 'c05f654e52a61be7f1a7ae94b0b408796732c145426be0e3de825b241b6054c5'

VM-Install-Single-Exe $toolName $category $exeUrl -exeSha256 $exeSha256 -consoleApp $true
