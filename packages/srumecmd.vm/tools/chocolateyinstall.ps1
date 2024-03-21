$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'SrumECmd'
$category = 'Forensic'

$zipUrl = 'https://f001.backblazeb2.com/file/EricZimmermanTools/net6/SrumECmd.zip'
$zipSha256 = 'acfff757f1da4e7cc5c7c521c8fd7eeda938ac9402ae4874f2c8f49239d52dc1'

VM-Install-From-Zip $toolName $category $zipUrl -zipSha256 $zipSha256 -consoleApp $true -innerFolder $false
