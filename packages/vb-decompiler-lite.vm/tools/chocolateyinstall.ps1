$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'VB Decompiler'
$category = 'Visual Basic'

$zipUrl = 'https://www.vb-decompiler.org/files/vb_decompiler_lite.zip'
$zipSha256 = 'ec754e61a55c6d4dfe1c5606749334abfbfd9e7a8b5363baf75aec8b5cde9811'

$toolDir = Join-Path ${Env:RAW_TOOLS_DIR} $toolName
$executablePath = (Join-Path $toolDir "$toolName.exe")
VM-Install-With-Installer $toolName $category "EXE" "/VERYSILENT /SUPPRESSMSGBOXES /NORESTART /SP- /Dir=`"$($toolDir)`"" $executablePath $zipUrl -sha256 $zipSha256
