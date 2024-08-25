$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'SecLists'
$category = 'Wordlists'

$zipUrl = 'https://github.com/danielmiessler/SecLists/archive/refs/tags/2024.3.zip'
$zipSha256 = '7c71ff1604df5a389d2cfb7804335791c49f606068c38ee4d7ff334620b114d3'

# This tool does not have a `.exe` associated with it, so this links it to the directory
VM-Install-From-Zip $toolName $category $zipUrl $zipSha256 -withoutBinFile -innerFolder $true
