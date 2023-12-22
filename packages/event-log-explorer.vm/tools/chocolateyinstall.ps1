$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'Event Log Explorer'
$category = 'Forensic'

$exeUrl = 'https://eventlogxp.com/download/elex_setup.exe'
$exeSha256 = 'caae0c43db65ce23dedad3e045f8459a2de0abbc289a2b83b8c55926fcff22bd'

$toolDir = Join-Path ${Env:ProgramFiles(x86)} $toolName
$executablePath = Join-Path $toolDir "elex.exe"

VM-Install-With-Installer -toolName $toolName -category $category -fileType "EXE" -silentArgs '/VERYSILENT /SUPPRESSMSGBOXES /NORESTART /SP- /MERGETASKS="!desktopicon"' -executablePath $executablePath -url $exeUrl -sha256 $exeSha256
