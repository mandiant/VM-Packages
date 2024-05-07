$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$pluginName = 'comida.py'
$pluginUrl = 'https://raw.githubusercontent.com/airbus-cert/comida/177ea45f98b153552dc13545dda64a6a26fab0a0/comida.py'
$pluginSha256 = '95e33b6b8afd44a4c924ae2bd8779c645751926f9312a99d3332066388d55be6'

VM-Install-IDA-Plugin -pluginName $pluginName -pluginUrl $pluginUrl -pluginSha256 $pluginSha256
