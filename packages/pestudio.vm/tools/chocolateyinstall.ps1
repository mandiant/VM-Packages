$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'pestudio'
$category = 'PE'

$zipUrl = 'https://www.winitor.com/tools/pestudio/current/pestudio-9.57.zip'
$zipSha256 = 'df0664f07bc1561788abfad101ac371e37310bb20f50d5171fb3edf65e950eeb'

VM-Install-From-Zip $toolName $category $zipUrl -zipSha256 $zipSha256 -innerFolder $true
