$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

try {
    # Install requirements: https://github.com/OALabs/hashdb-ida/blob/1.9.0/requirements.txt
    VM-Pip-Install requests

    $pluginName = 'hashdb.py'
    $pluginUrl = 'https://github.com/OALabs/hashdb-ida/releases/download/1.9.0/hashdb.py'
    $pluginSha256 = '45c55bd5c234e42b02435f2c93637dc33c13fc2f92fd060bcd755533eaa2807d'

    VM-Install-IDA-Plugin -pluginName $pluginName -pluginUrl $pluginUrl -pluginSha256 $pluginSha256
} catch {
  VM-Write-Log-Exception $_
}
