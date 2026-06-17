$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking


# Install requirements: https://github.com/OALabs/hashdb-ida/blob/1.12.0/requirements.txt
VM-Pip-Install requests

$pluginName = 'hashdb.py'
$pluginUrl = 'https://github.com/OALabs/hashdb-ida/releases/download/1.12.0/hashdb.py'
$pluginSha256 = '0547799fc9df32eb2e3114ebbb72583a473da9c29f40bffb911c59cf38651e4a'

VM-Install-IDA-Plugin -pluginName $pluginName -pluginUrl $pluginUrl -pluginSha256 $pluginSha256
