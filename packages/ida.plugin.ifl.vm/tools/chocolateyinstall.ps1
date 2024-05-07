$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$pluginName = 'ifl.py'
$pluginUrl = 'https://raw.githubusercontent.com/hasherezade/ida_ifl/v1.4.4/ifl.py'
$pluginSha256 = '56bc0bd08dca09a44d007a9ec8a7ff80de0e3f143d1ad5c54c60beacec3e7eba'

VM-Install-IDA-Plugin -pluginName $pluginName -pluginUrl $pluginUrl -pluginSha256 $pluginSha256
