$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

try {
  $toolName = 'heidisql'
  $category = 'Utilities'
  $shimPath = '\HeidiSQL\heidisql.exe'

  $shortcutDir = Join-Path ${Env:TOOL_LIST_DIR} $category
  $shortcut = Join-Path $shortcutDir "$toolName.lnk"
  $executablePath = Join-Path ${Env:ProgramFiles} $shimPath -Resolve
  Install-ChocolateyShortcut -shortcutFilePath $shortcut -targetPath $executablePath -RunAsAdmin
  VM-Assert-Path $shortcut
  
  # Delete desktop shortcut
  $desktopShortcut = Join-Path ${Env:Public} "Desktop\$toolName.lnk"
  Test-Path $desktopShortcut
  Remove-Item $desktopShortcut -Force -ea 0

} catch {
  VM-Write-Log-Exception $_
}
