$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

try {
  $toolName = 'OpenVPN GUI'
  $category = 'Networking'
  $shimPath = 'C:\Program Files\OpenVPN\bin\openvpn-gui.exe'

  $shortcutDir = Join-Path ${Env:TOOL_LIST_DIR} $category
  $shortcut = Join-Path $shortcutDir "$toolName.lnk"
  $executablePath = Join-Path ${Env:ChocolateyInstall} $shimPath -Resolve
  Install-ChocolateyShortcut -shortcutFilePath $shortcut -targetPath $executablePath -RunAsAdmin
  VM-Assert-Path $shortcut

  # Removing the shortcut
  $desktopShortcut = Join-Path ${Env:Public} "Desktop\$toolName.lnk"
  Remove-Item $desktopShortcut -Force -ea 0

  # Removing OpenVPN from startup
  Remove-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Run' -Name 'OpenVPN-GUI' -ErrorAction SilentlyContinue

} catch {
  VM-Write-Log-Exception $_
}
