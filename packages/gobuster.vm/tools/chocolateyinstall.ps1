$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'GoBuster'
$category = 'Information Gathering'

$zipUrl = "https://github.com/OJ/gobuster/releases/download/v3.0.1/gobuster-windows-386.7z"
$zipSha256 = "824D8B306FA7D7C40CF1C131F4749024D855EC85DB96D914D4EF8EDB5B0F5DCF"

VM-Install-From-Zip $toolName $category $zipUrl $zipSha256 -consoleApp $true -innerFolder $true