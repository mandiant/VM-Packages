$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'JLECmd'
$category = 'Forensic'

$zipUrl = 'https://download.mikestammer.com/net6/JLECmd.zip'
$zipSha256 = '5897b96a8a34719304d7c8b287ceb15a6ca50ab565d7e1028f61ae3095e8bfeb'

VM-Install-From-Zip $toolName $category $zipUrl -zipSha256 $zipSha256 -consoleApp $true -innerFolder $false
