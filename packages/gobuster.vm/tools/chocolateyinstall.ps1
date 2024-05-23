$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'GoBuster'
$category = 'Reconnaissance'

$zipUrl = "https://github.com/OJ/gobuster/releases/download/v3.6.0/gobuster_Windows_x86_64.zip"
$zipSha256 = "23403da32e153849000d5e930506a46d0950bad2b0dcb5a7d325793f0ec8cf19"

VM-Install-From-Zip $toolName $category $zipUrl -zipSha256 $zipSha256 -consoleApp $true
