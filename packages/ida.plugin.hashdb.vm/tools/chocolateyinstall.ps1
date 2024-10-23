$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

try {
    # Install requirements: https://github.com/OALabs/hashdb-ida/blob/1.10.0/requirements.txt
    VM-Pip-Install requests

    $pluginName = 'hashdb.py'
    $pluginUrl = 'https://github.com/OALabs/hashdb-ida/releases/download/1.10.0/hashdb.py'
    $pluginSha256 = '8d153281ce9feccf00eb63c56fe0fbcc9534ce005635a91565c2340fbf5db651'

    VM-Install-IDA-Plugin -pluginName $pluginName -pluginUrl $pluginUrl -pluginSha256 $pluginSha256
} catch {
  VM-Write-Log-Exception $_
}
