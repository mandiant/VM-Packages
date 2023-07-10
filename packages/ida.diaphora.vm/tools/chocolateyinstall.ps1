$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'diaphora'
$category = 'Utilities'
$executableName = "diaphora.py"

$zipUrl = 'https://github.com/joxeankoret/diaphora/archive/refs/tags/3.0.zip'
$zipSha256 = '3d4a1bcaea155fbadecc823d59004580aae04edc0e98a96860df550bd4c08a40'

# Diaphora needs to be executed from IDA, do not install bin file
VM-Install-From-Zip $toolName $category $zipUrl -zipSha256 $zipSha256 -executableName $executableName -innerFolder $true -withoutBinFile
