$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'jadx'
$category = 'Java & Android'

$exeUrl = 'https://github.com/skylot/jadx/releases/download/v1.4.7/jadx-gui-1.4.7-no-jre-win.exe'
$exeSha256 = '1254d7f54037ec3b929e3e3eb9f9830a436fddefa95ef295d01cf79c75f845b9'

VM-Install-Single-Exe $toolName $category $exeUrl -exeSha256 $exeSha256 -consoleApp $false
