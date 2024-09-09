$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'RLA'
$category = 'Forensic'

$zipUrl = 'https://download.mikestammer.com/net6/rla.zip'
$zipSha256 = '1017f1d19d57665afd8fdfb13955a8280708931cb5cd75eca45ae28e23756b16'

VM-Install-From-Zip $toolName $category $zipUrl -zipSha256 $zipSha256 -consoleApp $true -innerFolder $false
