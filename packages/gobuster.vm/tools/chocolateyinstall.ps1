$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'GoBuster'
$category = VM-Get-Category($MyInvocation.MyCommand.Definition)

$zipUrl = "https://github.com/OJ/gobuster/releases/download/v3.8.0/gobuster_Windows_x86_64.zip"
$zipSha256 = "89205fcd3fb40873195fdd5da879d42a32f8eb962ae1467c403c9be3d0db127a"

VM-Install-From-Zip $toolName $category $zipUrl -zipSha256 $zipSha256 -consoleApp $true
