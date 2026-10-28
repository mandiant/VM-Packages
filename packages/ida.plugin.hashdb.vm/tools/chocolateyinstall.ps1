$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking


# Install requirements: https://github.com/OALabs/hashdb-ida/blob/1.13.0/requirements.txt
VM-Pip-Install requests

$pluginName = 'hashdb.py'
$pluginUrl = 'https://github.com/OALabs/hashdb-ida/releases/download/1.13.0/hashdb.py'
$pluginSha256 = '99f1d7282e29d4c2d53a1959619de655a6c34355b47d5667707956d6e5b74ebf'

VM-Install-IDA-Plugin -pluginName $pluginName -pluginUrl $pluginUrl -pluginSha256 $pluginSha256
