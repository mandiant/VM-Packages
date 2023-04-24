$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'pestudio'
$category = 'PE'

$zipUrl = 'https://www.winitor.com/tools/pestudio/current/pestudio.zip'
$zipSha256 = 'A544D14F3FA9EF2D371D078417828D6E7731E2A636534041339B6D806FF2F49C'

VM-Install-From-Zip $toolName $category $zipUrl -zipSha256 $zipSha256 -innerFolder $true
