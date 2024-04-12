$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'MicroBurst'
$category = 'Exploitation'

$zipUrl = 'https://github.com/NetSPI/MicroBurst/archive/10a4f9579de3fe687208f7a3d3d1120fbba408cc.zip'
$zipSha256 = '72700519c40fac2b01e5362e4d3d1e171e73910f8e9e9859753f26c64f0529d0'

$powershellCommand = 'Import-Module Az, .\Az\MicroBurst-Az.psm1, .\Misc\MicroBurst-Misc.psm1, .\REST\MicroBurst-AzureREST.psm1; Get-Command -Module MicroBurst-Az'

VM-Install-From-Zip $toolName $category $zipUrl $zipSha256 -innerFolder $true -powershellCommand $powershellCommand