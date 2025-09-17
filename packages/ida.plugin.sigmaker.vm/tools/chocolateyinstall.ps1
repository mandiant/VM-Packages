$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$pluginName = 'SigMaker64.dll'
$pluginUrl = 'https://github.com/A200K/IDA-Pro-SigMaker/releases/download/v1.0.10/SigMaker9_64.dll'
$pluginSha256 = 'd7c48abcb384ea5bdfdb909714e98aa3b5ac55021b129ef146cd80b5df81fff1'

VM-Install-IDA-Plugin -pluginName $pluginName -pluginUrl $pluginUrl -pluginSha256 $pluginSha256
