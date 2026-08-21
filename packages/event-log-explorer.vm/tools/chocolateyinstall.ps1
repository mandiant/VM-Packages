$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'Event Log Explorer'
$category = VM-Get-Category($MyInvocation.MyCommand.Definition)

$exeUrl = 'https://eventlogxp.com/download/elex_setup.exe'
$exeSha256 = 'b9c270fe9f7f8add0703ea1c4465fc3bd7f06cbdd82d01129c1d719d52af3a4c'

$toolDir = Join-Path ${Env:ProgramFiles(x86)} $toolName
$executablePath = Join-Path $toolDir "elex.exe"

VM-Install-With-Installer -toolName $toolName -category $category -fileType "EXE" -silentArgs '/VERYSILENT /SUPPRESSMSGBOXES /NORESTART /SP- /MERGETASKS="!desktopicon"' -executablePath $executablePath -url $exeUrl -sha256 $exeSha256
