$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'SystemInformer'
$category = VM-Get-Category($MyInvocation.MyCommand.Definition)

$zipUrl = 'https://github.com/winsiderss/si-builds/releases/download/3.2.25056.2303/systeminformer-3.2.25056.2303-release-bin.zip'
$zipSha256 = '581374dafa7631f11177ffe59266d343755f734edfd894c1bb21b49a4db74aa7'
$executableName = "amd64\$toolName.exe"

VM-Install-From-Zip $toolName $category $zipUrl -zipSha256 $zipSha256 -executableName $executableName -consoleApp $false
