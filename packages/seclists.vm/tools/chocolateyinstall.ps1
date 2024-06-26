$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'SecLists'
$category = 'Wordlists'

$zipUrl = 'https://github.com/danielmiessler/SecLists/archive/refs/tags/2024.2.zip'
$zipSha256 = '416fcd7143e4c336e9dcc45e08a55d137568b2369fd753050fc3274faed9f172'

# This tool does not have a `.exe` associated with it, so this links it to the directory
VM-Install-From-Zip $toolName $category $zipUrl $zipSha256 -withoutBinFile -innerFolder $true
