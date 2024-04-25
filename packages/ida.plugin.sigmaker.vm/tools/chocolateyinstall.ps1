$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$pluginName = 'SigMaker64.dll'
$pluginUrl = 'https://github.com/A200K/IDA-Pro-SigMaker/releases/download/v1.0.2/SigMaker64.dll'
$pluginSha256 = '0b44921a2fc35f13a2987fcf8830685d58f9d18bca760a9706ec4efe8b0d5d2f'

VM-Install-IDA-Plugin -pluginName $pluginName -pluginUrl $pluginUrl -pluginSha256 $pluginSha256
