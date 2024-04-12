$ErrorActionPreference = 'Continue'
Import-Module vm.common -Force -DisableNameChecking

try {
  $toolName = 'fakenet'
  $category = 'Networking'

  VM-Uninstall $toolName $category

  # Remove Desktop shortcut to FakeNet tool directory
  $desktopShortcut  = Join-Path ${Env:UserProfile} "Desktop\fakenet_logs.lnk"
  Remove-Item $desktopShortcut -Force -ea 0
} catch {
  VM-Write-Log-Exception $_
}
