$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'Event Log Explorer'
$category = 'Forensic'

$exeUrl = 'https://eventlogxp.com/download/elex_setup.exe'
$exeSha256 = '5049c96130396f407197a74fa571f10e4106bd0c13858e717fc11c535fded678'

$toolDir = Join-Path ${Env:ProgramFiles(x86)} $toolName
$executablePath = Join-Path $toolDir "elex.exe"

VM-Install-With-Installer -toolName $toolName -category $category -fileType "EXE" -silentArgs '/VERYSILENT /SUPPRESSMSGBOXES /NORESTART /SP- /MERGETASKS="!desktopicon"' -executablePath $executablePath -url $exeUrl -sha256 $exeSha256
