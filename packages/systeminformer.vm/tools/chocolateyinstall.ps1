$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'SystemInformer'
$category = 'Utilities'

$zipUrl = 'https://github.com/winsiderss/si-builds/releases/download/3.1.24208/systeminformer-3.1.24208-release-bin.zip'
$zipSha256 = '86aa4237565375ff214368fa855b8304bc4675f4bd547f7c7ef654c3a9be5fd1'
$executableName = "amd64\$toolName.exe"

VM-Install-From-Zip $toolName $category $zipUrl -zipSha256 $zipSha256 -executableName $executableName -consoleApp $false
