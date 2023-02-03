$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'hollows_hunter'
$category = 'PE'

$zipUrl = 'https://github.com/hasherezade/hollows_hunter/releases/download/v0.3.5/hollows_hunter32.zip'
$zipSha256 = '0bbb0b794ac0b1c179a993a7bd26489fc1b8497aca05fa797b49f3d9bc71a6ca'
$zipUrl_64 = 'https://github.com/hasherezade/hollows_hunter/releases/download/v0.3.5/hollows_hunter64.zip'
$zipSha256_64 = '4ab368a12b761f4b351d0f9d60d4a1a1f80e6885025c798b4a972ab106c2d162'

VM-Install-From-Zip $toolName $category $zipUrl -zipSha256 $zipSha256 -zipUrl_64 $zipUrl_64 -zipSha256_64 $zipSha256_64 -consoleApp $true

