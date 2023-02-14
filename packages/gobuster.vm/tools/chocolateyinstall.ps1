$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'GoBuster'
$category = 'Information Gathering'

$zipUrl = "https://github.com/OJ/gobuster/releases/download/v3.4.0/gobuster-windows-386.7z"
$zipSha256 = "0019dfc4b32d63c1392aa264aed2253c1e0c2fb09216f8e2cc269bbfb8bb49b5"

VM-Install-From-Zip $toolName $category $zipUrl -zipSha256 $zipSha256 -consoleApp $true -innerFolder $true
