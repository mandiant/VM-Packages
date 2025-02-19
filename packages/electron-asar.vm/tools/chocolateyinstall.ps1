$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'asar'
$category = 'PE'

$zipUrl = 'https://github.com/electron/asar/archive/refs/tags/v3.2.17.zip'
$zipSha256 = 'd6e05cfe3e81ac9ae9702d2d0bbdd1589af86979750b7d42dae57f4c554aa729'
$command = 'asar'

VM-Install-Node-Tool-From-Zip $toolName $category $zipUrl -zipSha256 $zipSha256 -command $command 
