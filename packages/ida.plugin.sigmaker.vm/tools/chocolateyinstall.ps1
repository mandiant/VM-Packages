$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$pluginName = 'SigMaker64.dll'
$pluginUrl = 'https://github.com/A200K/IDA-Pro-SigMaker/releases/download/v1.0.9/SigMaker9_64.dll'
$pluginSha256 = 'cec05a96867f51dff686d72384f6be98c763dfda9da2ebbe653510620bfb7070'

VM-Install-IDA-Plugin -pluginName $pluginName -pluginUrl $pluginUrl -pluginSha256 $pluginSha256
