$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'Autopsy'
$category = VM-Get-Category($MyInvocation.MyCommand.Definition)

$exeUrl = "https://github.com/sleuthkit/autopsy/releases/download/autopsy-4.21.0/autopsy-4.21.0-64bit.msi"
$exeSha256 = '8401a11e0e276274f078eb613ce8494dd894617d436ba326be1cda0d2fd8ef0a'

$toolDir = Join-Path ${Env:ProgramFiles} $toolName
$executablePath = Join-Path $toolDir "bin\autopsy64.exe"

VM-Install-With-Installer -toolName $toolName -category $category -fileType "MSI" -silentArgs "APPDIR=`"${toolDir}`" /qn /norestart" -executablePath $executablePath -url $exeUrl -sha256 $exeSha256

try {
    $desktopShortcutPath = "${Env:HomeDrive}\Users\*\Desktop\$toolName*.lnk"
    Remove-Item -Path $desktopShortcutPath -ErrorAction SilentlyContinue
} catch {
    VM-Write-Log-Exception $_
}
