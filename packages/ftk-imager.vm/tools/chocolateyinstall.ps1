$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'FTK Imager'
$category = VM-Get-Category($MyInvocation.MyCommand.Definition)

$exeUrl = 'https://d1kpmuwb7gvu1i.cloudfront.net/Imgr/4.7.3.81%20Release/Exterro_FTK_Imager_%28x64%29-4.7.3.81.exe'
$exeSha256 = '443843a3923a55d479d6ebb339dfbec12b5c1aabed196bf0541669abbe9b1c51'

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
