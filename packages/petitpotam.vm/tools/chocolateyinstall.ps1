$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'PetitPotam'
$category = 'Exploitation'

$zipUrl = 'https://github.com/topotam/PetitPotam/archive/d83ac8f2dd34654628c17490f99106eb128e7d1e.zip'
$zipSha256 = '5429479879877c2a6263d79c1a83fbcbd0f9f37bf9870c155358d9dc25662862'

VM-Install-From-Zip $toolName $category $zipUrl $zipSha256 -innerFolder $true
