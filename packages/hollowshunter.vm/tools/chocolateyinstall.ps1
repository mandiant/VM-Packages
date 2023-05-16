$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'hollows_hunter'
$category = 'PE'

$zipUrl = 'https://github.com/hasherezade/hollows_hunter/releases/download/v0.3.6/hollows_hunter32.zip'
$zipSha256 = 'b7a34de50fa8b7b289496c25cd96ecb79ca11dcc4a53586fdcd1a69ea32cb417'
$zipUrl_64 = 'https://github.com/hasherezade/hollows_hunter/releases/download/v0.3.6/hollows_hunter64.zip'
$zipSha256_64 = '3b5eadd70b44857db57328da8792e29d5b09e3e8561e609f389dd42b7747ef47'

VM-Install-From-Zip $toolName $category $zipUrl -zipSha256 $zipSha256 -zipUrl_64 $zipUrl_64 -zipSha256_64 $zipSha256_64 -consoleApp $true

