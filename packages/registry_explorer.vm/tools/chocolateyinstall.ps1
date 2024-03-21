$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'RegistryExplorer'
$category = 'Registry'

$zipUrl = 'https://f001.backblazeb2.com/file/EricZimmermanTools/net6/RegistryExplorer.zip'
$zipSha256 = '50a11bd0a5e44dcea6469b8564eb3f010b9a8faf323ff6481222d391da26887e'

VM-Install-From-Zip $toolName $category $zipUrl -zipSha256 $zipSha256 -consoleApp $false -innerFolder $true
