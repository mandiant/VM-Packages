$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'd2j-dex2jar'
$category = 'Java & Android'

$zipUrl = 'https://github.com/pxb1988/dex2jar/releases/download/v2.3/dex2jar-v2.zip'
$zipSha256 = 'd0507b6277193476ae29351905b5fa9b20d1a9a5ce119b46d87e5b188edf859e'

VM-Install-From-Zip $toolName $category $zipUrl -zipSha256 $zipSha256 -consoleApp $true -executableName "$toolName.bat" -innerFolder $true
