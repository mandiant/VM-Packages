$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'pestudio'
$category = 'PE'

$zipUrl = 'https://www.winitor.com/tools/pestudio/current/pestudio-9.60.zip'
$zipSha256 = 'acc8eac2b5060d81c1285c2c6b050d18a045b7c659e6bf11cfcaada3c00bd1dd'

VM-Install-From-Zip $toolName $category $zipUrl -zipSha256 $zipSha256 -innerFolder $true
