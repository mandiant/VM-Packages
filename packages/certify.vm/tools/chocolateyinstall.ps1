$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'Certify'
$category = 'Exploitation'

$zipUrl = 'https://github.com/GhostPack/Certify/archive/fb297ad30476cfdba745b9062171cd7ac145a16d.zip'
$zipSha256 = '4827485203eb08271e953bbd5816e95bf8b0b897ae0937c798525afe7ed5b9e0'

VM-Install-From-Zip $toolName $category $zipUrl $zipSha256 -withoutBinFile -innerFolder $true
