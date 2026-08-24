$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'Event Log Explorer'
$category = VM-Get-Category($MyInvocation.MyCommand.Definition)

$exeUrl = 'https://eventlogxp.com/download/elex_setup.exe'
$exeSha256 = '2fe9a919bd23bda63691b6e0c43fc134edf904f8f65cb5573529aaf81ec7a66b'

$toolDir = Join-Path ${Env:ProgramFiles(x86)} $toolName
$executablePath = Join-Path $toolDir "elex.exe"

VM-Install-With-Installer -toolName $toolName -category $category -fileType "EXE" -silentArgs '/VERYSILENT /SUPPRESSMSGBOXES /NORESTART /SP- /MERGETASKS="!desktopicon"' -executablePath $executablePath -url $exeUrl -sha256 $exeSha256
