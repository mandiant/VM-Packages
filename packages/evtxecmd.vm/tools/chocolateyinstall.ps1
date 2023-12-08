$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'EvtxECmd'
$category = 'Forensic'

$zipUrl = 'https://f001.backblazeb2.com/file/EricZimmermanTools/net6/EvtxECmd.zip'
$zipSha256 = 'e1b4a5f9b09eca3c057cdc2d0ed1a28fe0c24dc90f9f68b7e0572e373dce86a6'

VM-Install-From-Zip $toolName $category $zipUrl -zipSha256 $zipSha256 -consoleApp $true -innerFolder $true
