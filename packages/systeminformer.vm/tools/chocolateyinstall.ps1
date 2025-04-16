$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'SystemInformer'
$category = VM-Get-Category($MyInvocation.MyCommand.Definition)

$zipUrl = 'https://github.com/winsiderss/si-builds/releases/download/3.2.25102.2422/systeminformer-3.2.25102.2422-release-bin.zip'
$zipSha256 = 'afb7cd8ce609835be75120d9b00d130e9a41852ae63e7f86a002d5f165569849'
$executableName = "amd64\$toolName.exe"

VM-Install-From-Zip $toolName $category $zipUrl -zipSha256 $zipSha256 -executableName $executableName -consoleApp $false
