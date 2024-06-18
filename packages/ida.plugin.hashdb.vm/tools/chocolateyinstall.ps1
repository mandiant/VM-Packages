$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

try {
    # Install requirements: https://github.com/OALabs/hashdb-ida/blob/1.9.1/requirements.txt
    VM-Pip-Install requests

    $pluginName = 'hashdb.py'
    $pluginUrl = 'https://github.com/OALabs/hashdb-ida/releases/download/1.9.1/hashdb.py'
    $pluginSha256 = 'bd2022af77d27fb447adcad71bb9b33a255e59f646ca6961a64c78e26d2c4066'

    VM-Install-IDA-Plugin -pluginName $pluginName -pluginUrl $pluginUrl -pluginSha256 $pluginSha256
} catch {
  VM-Write-Log-Exception $_
}
