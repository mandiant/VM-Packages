$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'Event Log Explorer'
$category = VM-Get-Category($MyInvocation.MyCommand.Definition)

$exeUrl = 'https://eventlogxp.com/download/elex_setup.exe'
$exeSha256 = '45fdb740ea5acbfc1b5386b019fa0bb6d19fa5cae382bebd01834f11d725df12'

$toolDir = Join-Path ${Env:ProgramFiles(x86)} $toolName
$executablePath = Join-Path $toolDir "elex.exe"

VM-Install-With-Installer -toolName $toolName -category $category -fileType "EXE" -silentArgs '/VERYSILENT /SUPPRESSMSGBOXES /NORESTART /SP- /MERGETASKS="!desktopicon"' -executablePath $executablePath -url $exeUrl -sha256 $exeSha256
