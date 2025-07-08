$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'SystemInformer'
$category = VM-Get-Category($MyInvocation.MyCommand.Definition)

$zipUrl = 'https://github.com/winsiderss/si-builds/releases/download/3.2.25113.1114/systeminformer-3.2.25113.1114-release-bin.zip'
$zipSha256 = '43a19bd901f68e1e1057cffd0b8b0d30fb596acb03b3e1409ff055fe4b6bbdc8'
$executableName = "amd64\$toolName.exe"

VM-Install-From-Zip $toolName $category $zipUrl -zipSha256 $zipSha256 -executableName $executableName -consoleApp $false
