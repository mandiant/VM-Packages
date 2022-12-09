$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'exeinfope'
$category = 'Utilities'

$zipUrl = 'https://github.com/ExeinfoASL/ASL/raw/dcaede39806993f5e68ab1c04e650319d3852170/exeinfope.zip'
$zipSha256 = '7eecd5d2dd37dbbc5169c6c7d179a4f5ac45a179c74a707a7d2d972b63b09fc5'

VM-Install-From-Zip $toolName $category $zipUrl -zipSha256 $zipSha256 -innerFolder $true
