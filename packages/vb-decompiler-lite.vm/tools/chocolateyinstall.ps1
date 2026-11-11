$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'VB Decompiler'
$category = VM-Get-Category($MyInvocation.MyCommand.Definition)

$zipUrl = 'https://www.vb-decompiler.org/files/vb_decompiler_lite.zip'
$zipSha256 = 'cb61f15c0bd27a2dbef8fbe457e36da066b99d850756286e69c68668058f0447'

$toolDir = Join-Path ${Env:RAW_TOOLS_DIR} $toolName
$executablePath = (Join-Path $toolDir "VB Decompiler.exe")
VM-Install-With-Installer $toolName $category "EXE" "/VERYSILENT /SUPPRESSMSGBOXES /NORESTART /SP- /Dir=`"$($toolDir)`"" $executablePath $zipUrl -sha256 $zipSha256
