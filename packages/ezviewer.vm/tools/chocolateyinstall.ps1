$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'EZViewer'
$category = 'Office'

$zipUrl = 'https://f001.backblazeb2.com/file/EricZimmermanTools/net6/EZViewer.zip'
$zipSha256 = '86a27bf8f4744d283c33d7321ad8a510e6f4067ec776cfdf1cc4748a0684072d'

VM-Install-From-Zip $toolName $category $zipUrl -zipSha256 $zipSha256 -consoleApp $false -innerFolder $true
