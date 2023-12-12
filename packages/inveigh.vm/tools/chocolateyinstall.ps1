$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'Inveigh'
$category = 'Credential Access'

$zipUrl = 'https://github.com/Kevin-Robertson/Inveigh/releases/download/v2.0.10/Inveigh-net7.0-v2.0.10.zip'
$zipSha256 = '8c61ccdccc84f2223c5c3da2014deb79cf807c26db0b018373e776baa26537bc'

VM-Install-From-Zip $toolName $category $zipUrl -zipSha256 $zipSha256 -consoleApp $true
