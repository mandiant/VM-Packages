$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'AmcacheParser'
$category = 'Forensic'

$zipUrl = 'https://download.mikestammer.com/net6/AmcacheParser.zip'
$zipSha256 = '0e0214d3b8d17500946e445f3dec92f9485d00f788316eaa5ca78ebb31c92d78'

VM-Install-From-Zip $toolName $category $zipUrl -zipSha256 $zipSha256 -consoleApp $true -innerFolder $false
