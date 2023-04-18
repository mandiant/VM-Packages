$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'BloodHound'
$category = 'Information Gathering'

$zipUrl = "https://github.com/BloodHoundAD/BloodHound/releases/download/v4.3.0/BloodHound-win32-ia32.zip"
$zipSha256 = "52ce1c2667bd54eafb7485098eb77558883d8f0c091ff89faf761e722f5e9d45"

VM-Install-From-Zip $toolName $category $zipUrl -zipSha256 $zipSha256 -innerFolder $true
