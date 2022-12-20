$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

try {
    $toolName = 'vbdec'
    $category = 'VB'

    $exeUrl = 'https://github.com/dzzie/pdfstreamdumper/releases/download/vbdec_12.7.22/VBDEC_Setup_SnapShot_12.8.22.exe'
    $exeSha256 = 'BAED0DA101D1C5D5A326D5C6D004C811C9D23CB76638F79EAFFA9150DB7E8535'

    $toolDir = Join-Path ${Env:RAW_TOOLS_DIR} $toolName
    $executablePath = (Join-Path $toolDir "vbdec.exe")
    VM-Install-With-Installer $toolName $category "EXE" "/VERYSILENT /SUPPRESSMSGBOXES /NORESTART /SP- /Dir=`"$($toolDir)`"" $executablePath $exeUrl -sha256 $zipSha256

    $desktopShortcut = Join-Path $([Environment]::GetFolderPath("Desktop")) "VBDEC.exe.lnk"
    Remove-Item $desktopShortcut -Force -ea 0
} catch {
    VM-Write-Log-Exception $_
}

