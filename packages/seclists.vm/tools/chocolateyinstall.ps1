$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'SecLists'
$category = 'Wordlists'

$zipUrl = 'https://github.com/danielmiessler/SecLists/archive/refs/tags/2024.1.zip'
$zipSha256 = '189c9491898c070e3c6e7d51ecc370d96c9b13c9f289dc629ce078b0709780aa'

# This tool does not have a `.exe` associated with it, so this links it to the directory
VM-Install-From-Zip $toolName $category $zipUrl $zipSha256 -withoutBinFile -innerFolder $true
