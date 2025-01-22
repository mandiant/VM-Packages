$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'SystemInformer'
$category = 'Utilities'

$zipUrl = 'https://github.com/winsiderss/si-builds/releases/download/3.2.25016/systeminformer-3.2.25016-release-bin.zip'
$zipSha256 = '6be4867d42acbabf11e371a9cdeacd2f1c697d24ee55c3ef4de2f447bf0c559b'
$executableName = "amd64\$toolName.exe"

VM-Install-From-Zip $toolName $category $zipUrl -zipSha256 $zipSha256 -executableName $executableName -consoleApp $false
