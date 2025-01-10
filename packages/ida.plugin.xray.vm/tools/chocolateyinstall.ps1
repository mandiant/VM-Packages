$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$pluginName = 'xray.py'
$pluginUrl = 'https://raw.githubusercontent.com/patois/xray/10fda7eaa330e6c3450643c5b3829cdf759c8b20/xray.py'
$pluginSha256 = 'ff8a7c15a99fdabbebc6acc72dae8984542f00167857898cb31e4ed8d3e203c7'

VM-Install-IDA-Plugin -pluginName $pluginName -pluginUrl $pluginUrl -pluginSha256 $pluginSha256
