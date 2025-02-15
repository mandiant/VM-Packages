$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'SBECmd'
$category = 'Forensic'

$zipUrl = 'https://download.mikestammer.com/net6/SBECmd.zip'
$zipSha256 = '769c0c3548efa70f81748918a7cef017f106438e9fa516e1415450ce6310f451'

VM-Install-From-Zip $toolName $category $zipUrl -zipSha256 $zipSha256 -consoleApp $true -innerFolder $false
