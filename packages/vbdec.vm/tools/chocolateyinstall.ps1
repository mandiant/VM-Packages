$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

try {
    $toolName = 'vbdec'
    $category = 'Visual Basic'

    $exeUrl = 'http://sandsprite.com/flare_vm/VBDEC_Setup_983E127DB204A3E50723E4A30D80EF8C.exe'
    $exeSha256 = 'E6FA33F1D8C51214B1B6E49665F1EDBCBF05399D57CC2A04CED0A74A194ADA63'

    $toolDir = Join-Path ${Env:RAW_TOOLS_DIR} $toolName
    $executablePath = (Join-Path $toolDir "vbdec.exe")
    VM-Install-With-Installer $toolName $category "EXE" "/VERYSILENT /SUPPRESSMSGBOXES /NORESTART /SP- /Dir=`"$($toolDir)`"" $executablePath $exeUrl -sha256 $exeSha256

    $desktopShortcut = Join-Path $([Environment]::GetFolderPath("Desktop")) "VBDEC.exe.lnk"
    Remove-Item $desktopShortcut -Force -ea 0
} catch {
    VM-Write-Log-Exception $_
}

