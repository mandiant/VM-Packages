$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

try {
  $toolName = 'pe-sieve'
  $category = 'Memory'
  $shimPath = 'bin\pe-sieve.exe'

  $executablePath = Join-Path ${Env:ChocolateyInstall} $shimPath -Resolve
  VM-Install-Shortcut $toolName $category $executablePath -consoleApp $true -RunAsAdmin
} catch {
  VM-Write-Log-Exception $_
}
