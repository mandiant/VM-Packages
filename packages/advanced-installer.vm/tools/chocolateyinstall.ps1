$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'Advanced Installer'
$category = VM-Get-Category($MyInvocation.MyCommand.Definition)

$msiUrl = "https://www.advancedinstaller.com/downloads/22.9/advinst.msi"
$msiSha256 = "2b34e8f584b952d0f49753a5bedd78b24c478915a7c82b5142953bfce23dfc28"

$toolDir = Join-Path ${Env:ProgramFiles(x86)} $toolName
$executablePath = Join-Path $toolDir "bin\x86\advinst.exe"

VM-Install-With-Installer -toolName $toolName -category $category -fileType "MSI" -silentArgs "APPDIR=`"${toolDir}`" /qn /norestart" -executablePath $executablePath -url $msiUrl -sha256 $msiSha256

$desktopShortcutPath = "${Env:HomeDrive}\Users\*\Desktop\$toolName*.lnk"
Remove-Item -Path $desktopShortcutPath -ErrorAction SilentlyContinue -Force
