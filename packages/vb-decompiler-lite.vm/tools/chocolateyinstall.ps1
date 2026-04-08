$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'VB Decompiler'
$category = VM-Get-Category($MyInvocation.MyCommand.Definition)

$zipUrl = 'https://www.vb-decompiler.org/files/vb_decompiler_lite.zip'
$zipSha256 = 'b632a3ac0b74b60c9b57d43b10c3f86d9d8a6eb156896e9bf299af61232d9917'

$toolDir = Join-Path ${Env:RAW_TOOLS_DIR} $toolName
$executablePath = (Join-Path $toolDir "$toolName.exe")
VM-Install-With-Installer $toolName $category "EXE" "/VERYSILENT /SUPPRESSMSGBOXES /NORESTART /SP- /Dir=`"$($toolDir)`"" $executablePath $zipUrl -sha256 $zipSha256
