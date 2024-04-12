$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'Remote Operations BOF'
$category = 'Reconnaissance'

$zipUrl = 'https://github.com/trustedsec/CS-Remote-OPs-BOF/archive/a7ef2b8551568778c2603a15ea83220188009a79.zip'
$zipSha256 = '61bf693272484d9f9ea25871ea57489cb24248c014782cacad1c1bb80e90962b'

# This tool does not have a `.exe` associated with it, so this links it to the directory
VM-Install-From-Zip $toolName $category $zipUrl $zipSha256 -withoutBinFile -innerFolder $true
