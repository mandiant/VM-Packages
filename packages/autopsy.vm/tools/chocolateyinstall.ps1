$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'Autopsy'
$category = VM-Get-Category($MyInvocation.MyCommand.Definition)

$exeUrl = "https://github.com/sleuthkit/autopsy/releases/download/autopsy-4.23.1/autopsy-4.23.1-64bit.msi"
$exeSha256 = 'f0f368e10cf615a805c85248356673a00c88a5e19c3b632859a1c98569ae03b6'

$toolDir = Join-Path ${Env:ProgramFiles} $toolName
$executablePath = Join-Path $toolDir "bin\autopsy64.exe"

VM-Install-With-Installer -toolName $toolName -category $category -fileType "MSI" -silentArgs "APPDIR=`"${toolDir}`" /qn /norestart" -executablePath $executablePath -url $exeUrl -sha256 $exeSha256

try {
    $desktopShortcutPath = "${Env:HomeDrive}\Users\*\Desktop\$toolName*.lnk"
    Remove-Item -Path $desktopShortcutPath -ErrorAction SilentlyContinue
} catch {
    VM-Write-Log-Exception $_
}
