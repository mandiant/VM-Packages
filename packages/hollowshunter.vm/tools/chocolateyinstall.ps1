$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'hollows_hunter'
$category = 'Memory'

$zipUrl = 'https://github.com/hasherezade/hollows_hunter/releases/download/v0.3.8.1/hollows_hunter32.zip'
$zipSha256 = 'c52859552dbbbf8409b207ebaf2e52ea605ffc6718c907428ef01065c2ed2948'
$zipUrl_64 = 'https://github.com/hasherezade/hollows_hunter/releases/download/v0.3.8.1/hollows_hunter64.zip'
$zipSha256_64 = '58cd2c5412fc6c615ff2ae8244b1d2b252d30e801f97a59b5d3d96c117848c08'

VM-Install-From-Zip $toolName $category $zipUrl -zipSha256 $zipSha256 -zipUrl_64 $zipUrl_64 -zipSha256_64 $zipSha256_64 -consoleApp $true

