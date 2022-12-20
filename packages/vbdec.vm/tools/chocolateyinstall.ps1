$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

try {
    $toolName = 'vbdec'
    $category = 'VB'

    $exeUrl = 'https://github.com/dzzie/pdfstreamdumper/releases/download/vbdec_12.7.22/VBDEC_Setup_SnapShot_12.8.22.exe'
    $exeSha256 = 'baed0da101d1c5d5a326d5c6d004c811c9d23cb76638f79eaffa9150db7e8535'

    $toolDir = Join-Path ${Env:RAW_TOOLS_DIR} $toolName
    $executablePath = (Join-Path $toolDir "vbdec.exe")
    VM-Install-With-Installer $toolName $category "EXE" "/VERYSILENT /SUPPRESSMSGBOXES /NORESTART /SP- /Dir=`"$($toolDir)`"" $executablePath $exeUrl -sha256 $exeSha256

    $desktopShortcut = Join-Path $([Environment]::GetFolderPath("Desktop")) "VBDEC.exe.lnk"
    Remove-Item $desktopShortcut -Force -ea 0
} catch {
    VM-Write-Log-Exception $_
}

