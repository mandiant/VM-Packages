$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'Hasher'
$category = 'File Information'

$zipUrl = 'https://f001.backblazeb2.com/file/EricZimmermanTools/hasher.zip'
$zipSha256 = '1693875e5f830e582dc01778cae34e50c1e28d472ced9fe1caeac89843b58cfa'

VM-Install-From-Zip $toolName $category $zipUrl -zipSha256 $zipSha256 -consoleApp $false -innerFolder $true
