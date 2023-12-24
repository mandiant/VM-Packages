$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'PMA-labs'
$category = 'Utilities'

$zipUrl = 'https://raw.githubusercontent.com/mikesiko/PracticalMalwareAnalysis-Labs/5f55de02a10748247f7511dafaaf18a37d332ff5/PracticalMalwareAnalysis-Labs.exe'
$zipSha256 = '704138bec89cf9e7f00fbce100dbc09cf133d16dc0203806392f0e153c43c68c'

VM-Install-From-Zip $toolName $category $zipUrl -zipSha256 $zipSha256 -executableName "Practical Malware Analysis Labs\BinaryCollection" -withoutBinFile
