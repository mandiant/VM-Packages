$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

try {
  $category = 'Utilities'

  $shortcutDir = Join-Path ${Env:TOOL_LIST_DIR} $category
  $shortcut32 = Join-Path $shortcutDir "apimonitor-x86.lnk"
  $executablePath32 = Join-Path ${Env:ChocolateyInstall} "bin\apimonitor-x86.exe" -Resolve
  Install-ChocolateyShortcut -shortcutFilePath $shortcut32 -targetPath $executablePath32 -RunAsAdmin
  VM-Assert-Path $shortcut32

  $shortcut64 = Join-Path $shortcutDir "apimonitor-x64.lnk"
  $executablePath64 = Join-Path ${Env:ChocolateyInstall} "bin\apimonitor-x64.exe" -Resolve
  Install-ChocolateyShortcut -shortcutFilePath $shortcut64 -targetPath $executablePath64 -RunAsAdmin
  VM-Assert-Path $shortcut64

} catch {
  VM-Write-Log-Exception $_
}
