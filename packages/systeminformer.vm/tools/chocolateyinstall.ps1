$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'SystemInformer'
$category = 'Utilities'

$zipUrl = 'https://github.com/winsiderss/si-builds/releases/download/3.2.25015/systeminformer-3.2.25015-release-bin.zip'
$zipSha256 = '537a003f69244daa680cca737de96c8d96b1e573dc674276a22730e06c13caeb'
$executableName = "amd64\$toolName.exe"

VM-Install-From-Zip $toolName $category $zipUrl -zipSha256 $zipSha256 -executableName $executableName -consoleApp $false
