$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'BloodHound'
$category = 'Information Gathering'

$zipUrl = "https://github.com/BloodHoundAD/BloodHound/releases/download/v4.3.0/BloodHound-win32-ia32.zip"
$zipSha256 = "88e13a123b49e19188a4d51b83b060fd5fe0d6b4cdd96e6557792d229d339f64"

VM-Install-From-Zip $toolName $category $zipUrl -zipSha256 $zipSha256 -innerFolder $true
