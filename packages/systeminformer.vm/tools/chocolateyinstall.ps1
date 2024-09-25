$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'SystemInformer'
$category = 'Utilities'

$zipUrl = 'https://github.com/winsiderss/si-builds/releases/download/3.1.24266/systeminformer-3.1.24266-release-bin.zip'
$zipSha256 = 'c443e3be5a047b52757b070b89136560c0a038d8acd07adca480d3cf1e572c42'
$executableName = "amd64\$toolName.exe"

VM-Install-From-Zip $toolName $category $zipUrl -zipSha256 $zipSha256 -executableName $executableName -consoleApp $false
