$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'PEAnatomist'
$category = 'PE'

$zipUrl = 'https://web.archive.org/web/20240117120829/https://rammerlabs.alidml.ru/files/0000-0002-29CD-0000/PEAnatomist-0.2.zip'
$zipSha256 = '4e24cecdce194b821828635997d441b800eecdfe79f8bd4f90af98accd3953dd'

VM-Install-From-Zip $toolName $category $zipUrl -zipSha256 $zipSha256 -consoleApp $false
