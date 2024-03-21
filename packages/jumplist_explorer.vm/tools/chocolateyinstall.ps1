$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'JumpListExplorer'
$category = 'Forensic'

$zipUrl = 'https://f001.backblazeb2.com/file/EricZimmermanTools/net6/JumpListExplorer.zip'
$zipSha256 = '5543774e73f6c42ece035b95f2e3689a1a52ef89cb04b15512da264c8bc799f9'

VM-Install-From-Zip $toolName $category $zipUrl -zipSha256 $zipSha256 -consoleApp $false -innerFolder $true
