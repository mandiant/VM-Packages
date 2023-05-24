$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'MFASweep'
$category = 'Reconnaissance'

$ps1Url = 'https://raw.githubusercontent.com/dafthack/MFASweep/d624cdedb3eaa40518990b234b308c1ec8f6bbc7/MFASweep.ps1'
$ps1Sha256 = 'e5df6d6914a197455d4779c50863f86c5086abbcb6638a4d9ea50598313c1481'

$ps1Cmd = 'Import-Module .\MFASweep.ps1; Get-Help Invoke-MFASweep'

VM-Install-Single-Ps1 $toolName $category $ps1Url -ps1Sha256 $ps1Sha256 -ps1Cmd $ps1Cmd
