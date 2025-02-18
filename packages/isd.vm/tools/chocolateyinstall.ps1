$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

try {
    $toolName = 'Inno Setup Decompiler'
    $category = VM-Get-Category($MyInvocation.MyCommand.Definition)

    $zipUrl = 'https://github.com/dscharrer/innoextract/files/5507287/isdsetup.1.5.exe.zip'
    $zipSha256 = '8fe99b5a989066131b6553394c2c93eed5adbd9430494ab921aafd74d2c818dc'

    $toolDir = Join-Path ${Env:RAW_TOOLS_DIR} $toolName
    $executablePath = (Join-Path $toolDir "PSUI.exe")
    VM-Install-With-Installer $toolName $category "EXE" "/VERYSILENT /SUPPRESSMSGBOXES /NORESTART /SP- /Dir=`"$($toolDir)`"" $executablePath $zipUrl -sha256 $zipSha256

    $desktopShortcut = Join-Path "C:\Users\Public\Desktop" "$toolName.lnk"
    Remove-Item $desktopShortcut -Force -ea 0
} catch {
    VM-Write-Log-Exception $_
}
