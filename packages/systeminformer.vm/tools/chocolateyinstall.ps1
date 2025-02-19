$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'SystemInformer'
$category = VM-Get-Category($MyInvocation.MyCommand.Definition)

$zipUrl = 'https://github.com/winsiderss/si-builds/releases/download/3.2.25036/systeminformer-3.2.25036-release-bin.zip'
$zipSha256 = 'b4f888e4d77288f52d4f23057009f65c97567ab48099b9500d90859e6903ea27'
$executableName = "amd64\$toolName.exe"

VM-Install-From-Zip $toolName $category $zipUrl -zipSha256 $zipSha256 -executableName $executableName -consoleApp $false
