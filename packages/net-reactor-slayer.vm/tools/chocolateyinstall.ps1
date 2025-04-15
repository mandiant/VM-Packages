$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

try {
  $toolName = 'NETReactorSlayer'
  $category = VM-Get-Category($MyInvocation.MyCommand.Definition)
  $shimPath = 'bin\NETReactorSlayer.exe'

  $shortcutDir = Join-Path ${Env:TOOL_LIST_DIR} $category
  $shortcut = Join-Path $shortcutDir "$toolName.lnk"
  $executablePath = Join-Path ${Env:ChocolateyInstall} $shimPath -Resolve
  $executableDir = Split-Path -Path $executablePath -Parent
  Install-ChocolateyShortcut -shortcutFilePath $shortcut -targetPath $executablePath -WorkingDirectory $executableDir -RunAsAdmin
  VM-Assert-Path $shortcut
} catch {
  VM-Write-Log-Exception $_
}
