$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

try {
  $toolLnk = 'apktool.lnk'
  $category = 'Android'
  $shimPath = 'bin\apktool.exe'

  $shortcutDir = Join-Path ${Env:TOOL_LIST_DIR} $category
  $shortcut = Join-Path $shortcutDir $toolLnk

  $executablePath = Join-Path ${Env:ChocolateyInstall} $shimPath -Resolve
  $executableIcon = ""  # no icon
  $executableCmd  = Join-Path ${Env:WinDir} "system32\cmd.exe"
  $executableDir  = Join-Path ${Env:UserProfile} "Desktop"
  $executableArgs = "/K `"cd `"$executableDir`" && `"$executablePath`""

  Install-ChocolateyShortcut -shortcutFilePath $shortcut -targetPath $executableCmd -Arguments $executableArgs -WorkingDirectory $executableDir -IconLocation $executableIcon
  VM-Assert-Path $shortcut
} catch {
  VM-Write-Log-Exception $_
}
