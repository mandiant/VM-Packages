$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'SystemInformer'
$category = 'Utilities'

$zipUrl = 'https://github.com/winsiderss/si-builds/releases/download/3.0.7353/systeminformer-3.0.7353-bin.zip'
$zipSha256 = '56d3e4677845b807f65caa17d0b16da115d4bd9e63ecd85d039791b3dd02bb45'
$executableName = "amd64\$toolName.exe"

VM-Install-From-Zip $toolName $category $zipUrl -zipSha256 $zipSha256 -executableName $executableName -consoleApp $false
