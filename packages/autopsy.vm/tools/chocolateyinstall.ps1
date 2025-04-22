$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'Autopsy'
$category = VM-Get-Category($MyInvocation.MyCommand.Definition)

$exeUrl = "https://github.com/sleuthkit/autopsy/releases/download/autopsy-4.22.1/autopsy-4.22.1-64bit.msi"
$exeSha256 = '371897fbc40786e1e263391a226ef3c3622462234601268e3118fd3d3ce97521'

$toolDir = Join-Path ${Env:ProgramFiles} $toolName
$executablePath = Join-Path $toolDir "bin\autopsy64.exe"

VM-Install-With-Installer -toolName $toolName -category $category -fileType "MSI" -silentArgs "APPDIR=`"${toolDir}`" /qn /norestart" -executablePath $executablePath -url $exeUrl -sha256 $exeSha256

try {
    $desktopShortcutPath = "${Env:HomeDrive}\Users\*\Desktop\$toolName*.lnk"
    Remove-Item -Path $desktopShortcutPath -ErrorAction SilentlyContinue
} catch {
    VM-Write-Log-Exception $_
}
