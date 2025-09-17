$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'hollows_hunter'
$category = VM-Get-Category($MyInvocation.MyCommand.Definition)

$zipUrl = 'https://github.com/hasherezade/hollows_hunter/releases/download/v0.4.1.1/hollows_hunter32.zip'
$zipSha256 = '7c43289eba4abd9fb2c99fc10d17d0824922b4f207bed13e0ee77d5ebd7fdd9b'
$zipUrl_64 = 'https://github.com/hasherezade/hollows_hunter/releases/download/v0.4.1.1/hollows_hunter64.zip'
$zipSha256_64 = '00bff71b46f81f1c5f5d6c64fe8682a695a435d00e9b84112d79be05f8e1140c'

VM-Install-From-Zip $toolName $category $zipUrl -zipSha256 $zipSha256 -zipUrl_64 $zipUrl_64 -zipSha256_64 $zipSha256_64 -consoleApp $true

