$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'SystemInformer'
$category = 'Utilities'

$zipUrl = 'https://github.com/winsiderss/si-builds/releases/download/3.1.24333/systeminformer-3.1.24333-release-bin.zip'
$zipSha256 = 'de26c2da3b020df369d8bfa779161a6e762e5632b1a283acfbdba0bd88b0512d'
$executableName = "amd64\$toolName.exe"

VM-Install-From-Zip $toolName $category $zipUrl -zipSha256 $zipSha256 -executableName $executableName -consoleApp $false
