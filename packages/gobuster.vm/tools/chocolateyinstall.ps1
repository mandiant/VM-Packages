$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'GoBuster'
$category = VM-Get-Category($MyInvocation.MyCommand.Definition)

$zipUrl = "https://github.com/OJ/gobuster/releases/download/v3.8.1/gobuster_Windows_x86_64.zip"
$zipSha256 = "8698837017e6d268e7cee1017212c7cb299d36adcee6609b918904e1caabde75"

VM-Install-From-Zip $toolName $category $zipUrl -zipSha256 $zipSha256 -consoleApp $true
