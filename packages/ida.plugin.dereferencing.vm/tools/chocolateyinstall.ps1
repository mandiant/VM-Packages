$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$pluginName = 'dereferencing.py'
$pluginUrl = 'https://github.com/danigargu/deREferencing/archive/c5c606a9e70bff48214ce5286a37b15752fd8d1b.zip'
$pluginSha256 = '3ddec5c7569bc53883c5feaeb36d1145e2dde1c67491d14929af05938870dc1e'

VM-Install-IDA-Plugin -pluginName $pluginName -pluginUrl $pluginUrl -pluginSha256 $pluginSha256
