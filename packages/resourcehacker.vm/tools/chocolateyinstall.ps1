$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

try {
  $toolName = 'Resource Hacker'
  $category = 'Utilities'
  $shimPath = '\bin\ResourceHacker.exe'

  $executablePath = Join-Path ${Env:ChocolateyInstall} $shimPath -Resolve
  VM-Install-Shortcut $toolName $category $executablePath -RunAsAdmin
} catch {
  VM-Write-Log-Exception $_
}
