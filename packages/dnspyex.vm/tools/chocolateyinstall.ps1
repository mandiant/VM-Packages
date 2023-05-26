$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

try {
  $toolName = 'dnSpyEx'
  $category = 'dotNet'
  $shimPath = 'bin\dnSpy.Console.exe'

  $executablePath = Join-Path ${Env:ChocolateyInstall} $shimPath -Resolve
  VM-Install-Shortcut $toolName $category $executablePath -consoleApp $true -arguments $null
} catch {
  VM-Write-Log-Exception $_
}
