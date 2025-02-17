$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'SumECmd'
$category = 'Forensic'

$zipUrl = 'https://download.mikestammer.com/net6/SumECmd.zip'
$zipSha256 = 'f96cd86af40b143b005ad9c97e821927b51dff3842b310f7610bcea50629761e'

VM-Install-From-Zip $toolName $category $zipUrl -zipSha256 $zipSha256 -consoleApp $true -innerFolder $false
