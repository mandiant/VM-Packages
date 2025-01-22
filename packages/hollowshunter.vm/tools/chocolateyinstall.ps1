$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'hollows_hunter'
$category = 'Memory'

$zipUrl = 'https://github.com/hasherezade/hollows_hunter/releases/download/v0.4.0/hollows_hunter32.zip'
$zipSha256 = '42773616f35e29929ece409e65a6706f78e7619c755d33dd2a9f25713d4b172b'
$zipUrl_64 = 'https://github.com/hasherezade/hollows_hunter/releases/download/v0.4.0/hollows_hunter64.zip'
$zipSha256_64 = 'a7267844674184319047b4874fe283535f623ee2d18dfb2704c541c7cdd7712d'

VM-Install-From-Zip $toolName $category $zipUrl -zipSha256 $zipSha256 -zipUrl_64 $zipUrl_64 -zipSha256_64 $zipSha256_64 -consoleApp $true

