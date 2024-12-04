$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'VB Decompiler'
$category = 'Visual Basic'

$zipUrl = 'https://www.vb-decompiler.org/files/vb_decompiler_lite.zip'
$zipSha256 = '099760dcae9daa4c83885a3817cf6f17442ce709de0105993bfbb4f17db87e62'

$toolDir = Join-Path ${Env:RAW_TOOLS_DIR} $toolName
$executablePath = (Join-Path $toolDir "$toolName.exe")
VM-Install-With-Installer $toolName $category "EXE" "/VERYSILENT /SUPPRESSMSGBOXES /NORESTART /SP- /Dir=`"$($toolDir)`"" $executablePath $zipUrl -sha256 $zipSha256
