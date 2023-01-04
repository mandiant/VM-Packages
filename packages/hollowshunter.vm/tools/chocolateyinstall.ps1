$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'hollows_hunter'
$category = 'PE'

$zipUrl = 'https://github.com/hasherezade/hollows_hunter/releases/download/v0.3.5/hollows_hunter32.zip'
$zipSha256 = '0bbb0b794ac0b1c179a993a7bd26489fc1b8497aca05fa797b49f3d9bc71a6ca'

VM-Install-From-Zip $toolName $category $zipUrl -zipSha256 $zipSha256 -consoleApp $true

