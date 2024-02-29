$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

try {
  $toolName = 'Microsoft Windows Terminal'
  $category = 'Productivity Tools'
  $executablePath = '%LocalAppData%\Microsoft\WindowsApps\wt.exe'

  $shortcutDir = Join-Path ${Env:TOOL_LIST_DIR} $category
  $shortcut = Join-Path $shortcutDir "$toolName.lnk"
  # Create an admin shortcut that we can pin to the taskbar (analogous to the Admin Command Prompt for cmd.exe).
  Install-ChocolateyShortcut -shortcutFilePath $shortcut -targetPath $executablePath -RunAsAdmin
  VM-Assert-Path $shortcut
} catch {
  VM-Write-Log-Exception $_
}