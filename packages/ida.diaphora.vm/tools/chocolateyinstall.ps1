$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'diaphora'
$category = 'Utilities'
$executableName = "diaphora.py"

$zipUrl = 'https://github.com/joxeankoret/diaphora/archive/refs/tags/3.1.zip'
$zipSha256 = '5802ebca119d2af4bb99434ce575dc4299396e95c7c6b01895d4a34c8d9d559d'

# Diaphora needs to be executed from IDA, do not install bin file
VM-Install-From-Zip $toolName $category $zipUrl -zipSha256 $zipSha256 -executableName $executableName -innerFolder $true -withoutBinFile
