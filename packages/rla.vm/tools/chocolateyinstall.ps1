$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'RLA'
$category = 'Forensic'

$zipUrl = 'https://download.mikestammer.com/net6/rla.zip'
$zipSha256 = 'F30F9EF4F2E6BA8A002F8A799851D4173D85D5784FC3E388FBE1CFD525D20333'

VM-Install-From-Zip $toolName $category $zipUrl -zipSha256 $zipSha256 -consoleApp $true -innerFolder $false
