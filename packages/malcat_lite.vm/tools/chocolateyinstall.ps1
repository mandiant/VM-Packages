$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'malcat'
$category = 'Hex Editors'

$zipUrl = 'https://malcat.fr/latest/malcat_win64_lite.zip'
$zipSha256 = '3edf6223b2d8cb8feca8606c9081b1dfecb49dba2238a41a49833827422f53d6'

VM-Install-From-Zip $toolName $category $zipUrl -zipSha256 $zipSha256
