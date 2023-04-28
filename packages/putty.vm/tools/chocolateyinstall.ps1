$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

try {
  $toolName = 'PuTTY'
  $category = 'Networking'
  $shimPath = 'bin\putty.exe'

  $shortcutDir = Join-Path ${Env:TOOL_LIST_DIR} $category
  $shortcut = Join-Path $shortcutDir "$toolName.lnk"
  $executablePath = Join-Path ${Env:ChocolateyInstall} $shimPath -Resolve
  Install-ChocolateyShortcut -shortcutFilePath $shortcut -targetPath $executablePath -RunAsAdmin
  VM-Assert-Path $shortcut
} catch {
  VM-Write-Log-Exception $_
}
