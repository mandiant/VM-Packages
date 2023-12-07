$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'FTK Imager'
$category = 'Forensic'

$exeUrl = 'https://d1kpmuwb7gvu1i.cloudfront.net/AccessData_FTK_Imager_4.7.1.exe'
$exeSha256 = '57020f3e585d0f2a7ee783054c50886db4c65af1bbbe5e12e114dbf674326184'

$toolDir = Join-Path ${Env:ProgramFiles} "AccessData"
$toolDir = Join-Path $toolDir $toolName
$executablePath = Join-Path $toolDir "$toolName.exe"

VM-Install-With-Installer -toolName $toolName -category $category -fileType "EXE" -silentArgs "/S /v/qn" -executablePath $executablePath -url $exeUrl -sha256 $exeSha256

try {
    $desktopShortcutPath = "${Env:HomeDrive}\Users\*\Desktop\AccessData $toolName.lnk"
    Remove-Item -Path $desktopShortcutPath -ErrorAction SilentlyContinue
} catch {
    VM-Write-Log-Exception $_
}
