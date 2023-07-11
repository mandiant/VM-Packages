$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

try {
  $toolName = 'VNC-Viewer'
  $category = 'Utilities'
 

  $shortcutDir = Join-Path ${Env:TOOL_LIST_DIR} $category
  $shortcut = Join-Path $shortcutDir "$toolName.lnk"
  $executablePath = Join-Path ${Env:ProgramFiles} 'RealVNC\VNC Viewer\vncviewer.exe' -Resolve
  Install-ChocolateyShortcut -shortcutFilePath $shortcut -targetPath $executablePath -RunAsAdmin
  VM-Assert-Path $shortcut
} catch {
  VM-Write-Log-Exception $_
}
