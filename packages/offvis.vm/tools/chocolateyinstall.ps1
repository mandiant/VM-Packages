$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'OffVis'
$category = 'Documents'

$zipUrl = 'https://download.microsoft.com/download/1/2/7/127ba59a-4fe1-4acd-ba47-513ceef85a85/OffVis.zip'
$zipSha256 = '8432c2e81ab51bf46fc9a1b17629f4ff7c3902f976132477428b84918be08351'

VM-Install-From-Zip $toolName $category $zipUrl -zipSha256 $zipSha256 -consoleApp $false -innerFolder $false
