$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'SystemInformer'
$category = 'Utilities'

$zipUrl = 'https://github.com/winsiderss/si-builds/releases/download/3.2.25043.1925/systeminformer-3.2.25043.1925-release-bin.zip'
$zipSha256 = '80af1fd5bff08b11af34cb15b9eead8a12a9ee51d423d2f28cb0d6c433b6d6ad'
$executableName = "amd64\$toolName.exe"

VM-Install-From-Zip $toolName $category $zipUrl -zipSha256 $zipSha256 -executableName $executableName -consoleApp $false
