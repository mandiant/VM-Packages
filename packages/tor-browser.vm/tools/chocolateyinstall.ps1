$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

try {
  $toolName = 'Tor Browser'
  $category = 'Productivity Tools'
  $shimPath = '\lib\tor-browser\tools\tor-browser\Browser\firefox.exe'

  $shortcutDir = Join-Path ${Env:TOOL_LIST_DIR} $category
  $shortcut = Join-Path $shortcutDir "$toolName.lnk"
  $executablePath = Join-Path ${Env:ChocolateyInstall} $shimPath -Resolve
  Install-ChocolateyShortcut -shortcutFilePath $shortcut -targetPath $executablePath -RunAsAdmin
  VM-Assert-Path $shortcut

  # Delete Desktop shortcut
  $desktopShortcut = Join-Path ${Env:Public} "Desktop\$toolName.lnk"
  if (Test-Path $desktopShortcut) {
    Remove-Item $desktopShortcut -Force -ea 0
  }
} catch {
  VM-Write-Log-Exception $_
}
