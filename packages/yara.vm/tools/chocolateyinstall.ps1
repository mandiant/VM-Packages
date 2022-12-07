$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'yara'
$category = 'Forensic'

$zipUrl = 'https://github.com/VirusTotal/yara/releases/download/v4.2.3/yara-4.2.3-2029-win64.zip'
$zipSha256 = 'a71a7070bc6dd392e0c066a590d2262382b0c3d73e76cc0851dc33ab5d51d381'

VM-Install-From-Zip $toolName $category $zipUrl -zipSha256 $zipSha256
