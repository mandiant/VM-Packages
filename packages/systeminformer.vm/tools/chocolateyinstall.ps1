$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'SystemInformer'
$category = 'Utilities'

$zipUrl = 'https://github.com/winsiderss/si-builds/releases/download/3.0.7645/systeminformer-3.0.7645-release-bin.zip'
$zipSha256 = '8f41ecea8c2ca9c21b1585994c9d267e0939b9a31803f59d823eb02197876509'
$executableName = "amd64\$toolName.exe"

VM-Install-From-Zip $toolName $category $zipUrl -zipSha256 $zipSha256 -executableName $executableName -consoleApp $false
