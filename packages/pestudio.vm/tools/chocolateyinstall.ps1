$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'pestudio'
$category = 'PE'

$zipUrl = 'https://www.winitor.com/tools/pestudio/current/pestudio-9.58.zip'
$zipSha256 = '06c06dc1e6db6b8672b0827ca800affa0739a6878d9767d89122826ca0a2425e'

VM-Install-From-Zip $toolName $category $zipUrl -zipSha256 $zipSha256 -innerFolder $true
