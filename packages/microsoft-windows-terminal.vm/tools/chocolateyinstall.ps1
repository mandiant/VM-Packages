$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

try {
  $toolName = 'Microsoft Windows Terminal'
  $executablePath = '%LocalAppData%\Microsoft\WindowsApps\wt.exe'

  $shortcutDir = ${Env:RAW_TOOLS_DIR}
  $shortcut = Join-Path $shortcutDir "$toolName.lnk"
  # Create an admin shortcut that we can pin to the taskbar (analogous to the Admin Command Prompt for cmd.exe).
  Install-ChocolateyShortcut -shortcutFilePath $shortcut -targetPath $executablePath -RunAsAdmin
  VM-Assert-Path $shortcut
} catch {
  VM-Write-Log-Exception $_
}