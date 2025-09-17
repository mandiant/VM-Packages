$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'GoBuster'
$category = VM-Get-Category($MyInvocation.MyCommand.Definition)

$zipUrl = "https://github.com/OJ/gobuster/releases/download/v3.8.2/gobuster_Windows_x86_64.zip"
$zipSha256 = "677abe8e56c5455804225ad2264dc6e9981e99673ef3ccd6a2fa2af8a2e92aba"

VM-Install-From-Zip $toolName $category $zipUrl -zipSha256 $zipSha256 -consoleApp $true
