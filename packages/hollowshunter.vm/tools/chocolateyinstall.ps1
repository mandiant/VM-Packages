$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'hollows_hunter'
$category = 'PE'

$zipUrl = 'https://github.com/hasherezade/hollows_hunter/releases/download/v0.3.8/hollows_hunter32.zip'
$zipSha256 = 'f94758e6dfd6a3abb036d538d4532762566134cd48b00a22db54cb02003f348b'
$zipUrl_64 = 'https://github.com/hasherezade/hollows_hunter/releases/download/v0.3.8/hollows_hunter64.zip'
$zipSha256_64 = 'f316ecdfc8f5df76dac81473158b4a40564f7e1630c55f9be99667e87aebfddd'

VM-Install-From-Zip $toolName $category $zipUrl -zipSha256 $zipSha256 -zipUrl_64 $zipUrl_64 -zipSha256_64 $zipSha256_64 -consoleApp $true

