$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'pestudio'
$category = 'PE'

$zipUrl = 'https://www.winitor.com/tools/pestudio/current/pestudio-9.54.zip'
$zipSha256 = 'b9d4f4881ae8f54170fe97e35340aa651350f226da4ee2f0bf87ce9b5ac41ea4'

VM-Install-From-Zip $toolName $category $zipUrl -zipSha256 $zipSha256 -innerFolder $true
