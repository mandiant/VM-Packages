$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'diaphora'
$category = 'Utilities'
$executableName = "diaphora.py"

$zipUrl = 'https://github.com/joxeankoret/diaphora/archive/refs/tags/3.1.1.zip'
$zipSha256 = 'c7315edbcbd73ea4197779dec4f356e44dc9d4fc23065796fec5f02cb0088457'

# Diaphora needs to be executed from IDA, do not install bin file
VM-Install-From-Zip $toolName $category $zipUrl -zipSha256 $zipSha256 -executableName $executableName -innerFolder $true -withoutBinFile
