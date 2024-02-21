$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'LECmd'
$category = 'Forensic'

$zipUrl = 'https://f001.backblazeb2.com/file/EricZimmermanTools/net6/LECmd.zip'
$zipSha256 = '103bd3f0209c26598718c81585edbd624c4679a3e58ed369ade325e33fb7022a'

VM-Install-From-Zip $toolName $category $zipUrl -zipSha256 $zipSha256 -consoleApp $true -innerFolder $false
