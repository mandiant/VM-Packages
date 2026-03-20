$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$pluginName = 'delphihelper'
$pluginUrl = 'https://github.com/eset/DelphiHelper/archive/cb18a6f776b3b13e8f739052d35e6bf43d53292c.zip'
$pluginSha256 = '9ae247a8d3c54351530ba76278038414beab3389c5eb398f5251d8781ad995c3'

VM-Install-IDA-Plugin -pluginName $pluginName -pluginUrl $pluginUrl -pluginSha256 $pluginSha256
