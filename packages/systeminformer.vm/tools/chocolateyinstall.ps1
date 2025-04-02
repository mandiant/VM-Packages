$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'SystemInformer'
$category = VM-Get-Category($MyInvocation.MyCommand.Definition)

$zipUrl = 'https://github.com/winsiderss/si-builds/releases/download/3.2.25091.638/systeminformer-3.2.25091.638-release-bin.zip'
$zipSha256 = 'c5204b0ac5cc47e172f6998dedfe2f5f7d9f522f1545b2e0beca79f00aaed319'
$executableName = "amd64\$toolName.exe"

VM-Install-From-Zip $toolName $category $zipUrl -zipSha256 $zipSha256 -executableName $executableName -consoleApp $false
