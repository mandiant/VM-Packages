$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'peid'
$category = 'Utilities'

$zipUrl = "https://github.com/wolfram77web/app-peid/archive/refs/heads/master.zip"
$zipSha256 = "8c85ec0a15bb89443a154fac57af2d386af267e2cbc7c7315db0d6a905de9779"

VM-Install-From-Zip $toolName $category $zipUrl $zipSha256 -innerFolder $true

