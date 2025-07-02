$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'GoBuster'
$category = VM-Get-Category($MyInvocation.MyCommand.Definition)

$zipUrl = "https://github.com/OJ/gobuster/releases/download/v3.7.0/gobuster_Windows_x86_64.zip"
$zipSha256 = "424595b70c2084c8f7570f292c23cdb82ec1eae7b64baa5d50d92d5fd6885c51"

VM-Install-From-Zip $toolName $category $zipUrl -zipSha256 $zipSha256 -consoleApp $true
