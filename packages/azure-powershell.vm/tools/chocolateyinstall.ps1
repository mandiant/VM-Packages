$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

try {
  $toolName = 'Azure PowerShell'
  $category = 'Cloud'

  $shortcutDir = Join-Path ${Env:TOOL_LIST_DIR} $category
  $shortcut = Join-Path $shortcutDir "$toolName.lnk"
  $executablePwsh  = Join-Path ${Env:WinDir} "System32\WindowsPowerShell\v1.0\powershell.exe" -Resolve
  $executableArgs = "-NoExit -Command Get-AzContext -ListAvailable"
  Install-ChocolateyShortcut -shortcutFilePath $shortcut -targetPath $executablePwsh -Arguments $executableArgs -RunAsAdmin
  VM-Assert-Path $shortcut
} catch {
  VM-Write-Log-Exception $_
}
