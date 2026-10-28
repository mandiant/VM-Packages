$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'VB Decompiler'
$category = VM-Get-Category($MyInvocation.MyCommand.Definition)

$zipUrl = 'https://www.vb-decompiler.org/files/vb_decompiler_lite.zip'
$zipSha256 = 'f770af24ae3b235b2d9a0b58457bb8de37049298a23e9677cf0312206221eafd'

$toolDir = Join-Path ${Env:RAW_TOOLS_DIR} $toolName
$executablePath = (Join-Path $toolDir "VB Decompiler.exe")
VM-Install-With-Installer $toolName $category "EXE" "/VERYSILENT /SUPPRESSMSGBOXES /NORESTART /SP- /Dir=`"$($toolDir)`"" $executablePath $zipUrl -sha256 $zipSha256
