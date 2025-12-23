$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'Event Log Explorer'
$category = VM-Get-Category($MyInvocation.MyCommand.Definition)

$exeUrl = 'https://eventlogxp.com/download/elex_setup.exe'
$exeSha256 = 'e2be7332f60dd66c2ad3fe497c0e7937c01bf3627367346b28ed548b5c683eee'

$toolDir = Join-Path ${Env:ProgramFiles(x86)} $toolName
$executablePath = Join-Path $toolDir "elex.exe"

VM-Install-With-Installer -toolName $toolName -category $category -fileType "EXE" -silentArgs '/VERYSILENT /SUPPRESSMSGBOXES /NORESTART /SP- /MERGETASKS="!desktopicon"' -executablePath $executablePath -url $exeUrl -sha256 $exeSha256
