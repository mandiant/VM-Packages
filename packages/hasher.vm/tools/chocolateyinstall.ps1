$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'Hasher'
$category = 'File Information'

$zipUrl = 'https://f001.backblazeb2.com/file/EricZimmermanTools/hasher.zip'
$zipSha256 = '14ee103793fae4f165adc5e0a9424ca75ea0a4dc2e823dcc2b7cdeb2ae94483c'

VM-Install-From-Zip $toolName $category $zipUrl -zipSha256 $zipSha256 -consoleApp $false -innerFolder $true
