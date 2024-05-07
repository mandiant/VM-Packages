$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$pluginName = 'lighthouse_plugin.py'
$pluginUrl = 'https://github.com/gaasedelen/lighthouse/archive/562595be9bd99e8a5dfef6017d608467f5706630.zip'
$pluginSha256 = '48e83cf0a671fced325a4d78e987ab05eee2fa8ab199becea5ae372286510a0f'

VM-Install-IDA-Plugin -pluginName $pluginName -pluginUrl $pluginUrl -pluginSha256 $pluginSha256
