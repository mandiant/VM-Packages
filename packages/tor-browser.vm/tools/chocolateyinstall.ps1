$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

try {
  $toolName = 'Tor Browser'
  $category = VM-Get-Category($MyInvocation.MyCommand.Definition)
  $shimPath = '\lib\tor-browser\tools\tor-browser\Browser\firefox.exe'

  $shortcutDir = Join-Path ${Env:TOOL_LIST_DIR} $category
  $shortcut = Join-Path $shortcutDir "$toolName.lnk"
  $executablePath = Join-Path ${Env:ChocolateyInstall} $shimPath -Resolve
  Install-ChocolateyShortcut -shortcutFilePath $shortcut -targetPath $executablePath -RunAsAdmin
  VM-Assert-Path $shortcut

  VM-Remove-Desktop-Shortcut $toolName
} catch {
  VM-Write-Log-Exception $_
}
