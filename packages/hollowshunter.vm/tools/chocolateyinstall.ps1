$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'hollows_hunter'
$category = 'Memory'

$zipUrl = 'https://github.com/hasherezade/hollows_hunter/releases/download/v0.4.1/hollows_hunter32.zip'
$zipSha256 = '4312354f4b5c2665131c1db7cc4572b6c4ff09a0b9a8aec911e57a0dab400972'
$zipUrl_64 = 'https://github.com/hasherezade/hollows_hunter/releases/download/v0.4.1/hollows_hunter64.zip'
$zipSha256_64 = '59610f266b1b6cbe12c6bb7103c2c9f388b9b70ff5fa9b51d0d084de38dd963f'

VM-Install-From-Zip $toolName $category $zipUrl -zipSha256 $zipSha256 -zipUrl_64 $zipUrl_64 -zipSha256_64 $zipSha256_64 -consoleApp $true

