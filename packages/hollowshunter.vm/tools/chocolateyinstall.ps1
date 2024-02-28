$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'hollows_hunter'
$category = 'PE'

$zipUrl = 'https://github.com/hasherezade/hollows_hunter/releases/download/v0.3.9/hollows_hunter32.zip'
$zipSha256 = '3d96a22ea46952600e13bd1886314e3f0103750faa6bc79353851a15cf6d3431'
$zipUrl_64 = 'https://github.com/hasherezade/hollows_hunter/releases/download/v0.3.9/hollows_hunter64.zip'
$zipSha256_64 = 'f3ca153d51e32e892e2d8193307e5c75b82a3043072079fffa72c35c85d62bba'

VM-Install-From-Zip $toolName $category $zipUrl -zipSha256 $zipSha256 -zipUrl_64 $zipUrl_64 -zipSha256_64 $zipSha256_64 -consoleApp $true

