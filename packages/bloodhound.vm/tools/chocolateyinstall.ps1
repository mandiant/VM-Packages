$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'BloodHound'
$category = 'Information Gathering'

$zipUrl = "https://github.com/BloodHoundAD/BloodHound/releases/download/4.2.0/BloodHound-win32-ia32.zip"
$zipSha256 = "278934b8bf08d452d343a4da60e7453aba6bee5b20a7d91eaaac571131a4b623"

VM-Install-From-Zip $toolName $category $zipUrl -zipSha256 $zipSha256 -innerFolder $true
