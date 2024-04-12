$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'Statistically-Likely-Usernames'
$category = 'Wordlists'

$zipUrl = 'https://github.com/insidetrust/statistically-likely-usernames/archive/fc2321c65a1327a1db363764979e7c23d84dfd37.zip'
$zipSha256 = 'f52a84310e098d662ae212eccc979cefc1d061aa06aca765a8e0f98a4ece3c0c'

# This tool does not have a `.exe` associated with it, so this links it to the directory
VM-Install-From-Zip $toolName $category $zipUrl $zipSha256 -withoutBinFile -innerFolder $true
