$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'diaphora'
$category = 'Utilities'
$executableName = "diaphora.py"

$zipUrl = 'https://github.com/joxeankoret/diaphora/archive/refs/tags/3.2.0.zip'
$zipSha256 = 'a58f261214eba0c163824f7ce42bd5d7f04e0137e4f955464a13be4ecb612fb1'

# Diaphora needs to be executed from IDA, do not install bin file
VM-Install-From-Zip $toolName $category $zipUrl -zipSha256 $zipSha256 -executableName $executableName -innerFolder $true -withoutBinFile
