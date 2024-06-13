$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'pe_unmapper'
$category = 'PE'

$zipUrl = 'https://github.com/hasherezade/pe_unmapper/releases/download/v1.0/pe_unmapper.zip'
$zipSha256 = '02507845a7df01f9cccfe657548712bcce094e2940c7c63556ae39bbe7fc79dd'

VM-Install-From-Zip $toolName $category $zipUrl -zipSha256 $zipSha256 -consoleApp $true -innerFolder $false
