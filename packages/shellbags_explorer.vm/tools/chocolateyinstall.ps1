$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'ShellBagsExplorer'
$category = 'Forensic'

$zipUrl = 'https://f001.backblazeb2.com/file/EricZimmermanTools/net6/ShellBagsExplorer.zip'
$zipSha256 = '8f81e32b723115462d6245357d1c3d8a41fff2926c263c857a086765ce3f7ad2'

VM-Install-From-Zip $toolName $category $zipUrl -zipSha256 $zipSha256 -consoleApp $false -innerFolder $true
