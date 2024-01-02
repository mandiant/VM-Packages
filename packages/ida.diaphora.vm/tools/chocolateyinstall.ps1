$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'diaphora'
$category = 'Utilities'
$executableName = "diaphora.py"

$zipUrl = 'https://github.com/joxeankoret/diaphora/archive/refs/tags/3.1.2.zip'
$zipSha256 = 'c684a2138679fbb61b8562e0a671a5b296713fadac91b72c0f26d9a766dffee9'

# Diaphora needs to be executed from IDA, do not install bin file
VM-Install-From-Zip $toolName $category $zipUrl -zipSha256 $zipSha256 -executableName $executableName -innerFolder $true -withoutBinFile
