$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'Event Log Explorer'
$category = 'Forensic'

$exeUrl = 'https://eventlogxp.com/download/elex_setup.exe'
$exeSha256 = '84384a2d639a87f2d301315f1b670f702822c8b4e7a654d2a206d6cd6bac3dc3'

$toolDir = Join-Path ${Env:ProgramFiles(x86)} $toolName
$executablePath = Join-Path $toolDir "elex.exe"

VM-Install-With-Installer -toolName $toolName -category $category -fileType "EXE" -silentArgs '/VERYSILENT /SUPPRESSMSGBOXES /NORESTART /SP- /MERGETASKS="!desktopicon"' -executablePath $executablePath -url $exeUrl -sha256 $exeSha256
