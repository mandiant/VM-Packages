$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'SCLauncher'
$category = 'Utilities'

$exeUrl = 'https://github.com/jstrosch/sclauncher/releases/download/v0.0.3/sclauncher.exe'
$exeSha256 = '0c716e23af2ada3955993b08aa233db54a671c0b2da68072a8ad5bb470d4a47b'

VM-Install-Single-Exe $toolName $category $exeUrl -exeSha256 $exeSha256 -consoleApp $true
