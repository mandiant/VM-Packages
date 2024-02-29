$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

try {
    $toolName = 'PDFStreamDumper'
    $category = 'Documents'

    $exeUrl = 'http://sandsprite.com/flare_vm/PDFStreamDumper_Setup_C26068186F63DCCE9CC57502BE742C728110EAB07570C319A0D7D10587A6E22D.exe'
    $exeSha256 = 'c26068186f63dcce9cc57502be742c728110eab07570c319a0d7d10587a6e22d'

    $toolDir = Join-Path ${Env:RAW_TOOLS_DIR} $toolName
    $executablePath = (Join-Path $toolDir "$toolName.exe")
    VM-Install-With-Installer -toolName $toolName -category $category -fileType "EXE" -silentArgs "/VERYSILENT /SUPPRESSMSGBOXES /NORESTART /SP- /Dir=`"$($toolDir)`"" -executablePath $executablePath -url $exeUrl -sha256 $exeSha256

    $desktopShortcut = Join-Path ${Env:UserProfile} "Desktop\$toolName.exe.lnk"
    Remove-Item $desktopShortcut -Force -ea 0
} catch {
    VM-Write-Log-Exception $_
}
