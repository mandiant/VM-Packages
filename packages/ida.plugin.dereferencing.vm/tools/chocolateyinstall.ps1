$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$pluginName = 'dereferencing.py'
$pluginUrl = 'https://github.com/danigargu/deREferencing/archive/ab106c1fa5969a5d7c27c8037b4aec446ad55a4d.zip'
$pluginSha256 = '83c0f9420075dbe5217f5fbf2413c7b1b72eadfaedfe2474b306e1e3eaae0aa8'
$pluginFiles = @('dereferencing', 'dereferencing.py')

VM-Install-IDA-Plugin -pluginName $pluginName -pluginUrl $pluginUrl -pluginSha256 $pluginSha256 -pluginFiles $pluginFiles
