$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'Hasher'
$category = 'File Information'

$zipUrl = 'https://download.mikestammer.com/hasher.zip'
$zipSha256 = '1fa5f2e91eed2c819a107a160a56d6cc3e12807355741db6dde4395cb6d527bf'

VM-Install-From-Zip $toolName $category $zipUrl -zipSha256 $zipSha256 -consoleApp $false -innerFolder $true
