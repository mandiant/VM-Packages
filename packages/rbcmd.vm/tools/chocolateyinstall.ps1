$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'RBCmd'
$category = 'Forensic'

$zipUrl = 'https://download.mikestammer.com/net6/RBCmd.zip'
$zipSha256 = '24c50fd79f7f6ddcee28c9a7b4928406ea47df82d1772f0fca00dac129f315c8'

VM-Install-From-Zip $toolName $category $zipUrl -zipSha256 $zipSha256 -consoleApp $true -innerFolder $false
