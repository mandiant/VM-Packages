$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'BloodHound'
$category = VM-Get-Category($MyInvocation.MyCommand.Definition)

$zipUrl = "https://github.com/BloodHoundAD/BloodHound/releases/download/v4.3.1/BloodHound-win32-ia32.zip"
$zipSha256 = "8d2a5cc827299d47424631882399067acf41d040c5b2aacf95092aec22d90c97"

VM-Install-From-Zip $toolName $category $zipUrl -zipSha256 $zipSha256 -innerFolder $true
