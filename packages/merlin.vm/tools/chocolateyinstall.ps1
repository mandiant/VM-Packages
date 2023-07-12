$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'Merlin'
$category = 'Command & Control'

$zipUrl = 'https://github.com/Ne0nd0g/merlin/releases/download/v1.5.1/merlinServer-Windows-x64.7z'
$zipSha256 = 'e3c6ee205a46c9619dbe12bb4d487b7bcc802113658f29397b5f550295fc76fc'

VM-Install-From-Zip $toolName $category $zipUrl -zipSha256 $zipSha256 -consoleApp $true
