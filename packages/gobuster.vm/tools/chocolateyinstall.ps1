$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'GoBuster'
$category = 'Information Gathering'

$zipUrl = "https://github.com/OJ/gobuster/releases/download/v3.5.0/gobuster_3.5.0_Windows_x86_64.zip"
$zipSha256 = "6b2df88eb8fc3046f54116992e9a924284d2ebb228c810eb8e799a18181e2ec8"

VM-Install-From-Zip $toolName $category $zipUrl -zipSha256 $zipSha256 -consoleApp $true
