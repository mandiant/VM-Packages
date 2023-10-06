$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

try {
  $toolName = 'apktool'
  $category = 'Java/Android'
  $shimPath = 'bin\apktool.exe'

  $shortcutDir = Join-Path ${Env:TOOL_LIST_DIR} $category
  $shortcut = Join-Path $shortcutDir "$toolName.lnk"

  $executablePath = Join-Path ${Env:ChocolateyInstall} $shimPath -Resolve
  $executableCmd  = Join-Path ${Env:WinDir} "system32\cmd.exe"
  $executableDir  = Join-Path ${Env:UserProfile} "Desktop"
  $executableArgs = "/K `"cd `"$executableDir`" && `"$executablePath`""

  Install-ChocolateyShortcut -shortcutFilePath $shortcut -targetPath $executableCmd -Arguments $executableArgs -WorkingDirectory $executableDir
  VM-Assert-Path $shortcut
} catch {
  VM-Write-Log-Exception $_
}
