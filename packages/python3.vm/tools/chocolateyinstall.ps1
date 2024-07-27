$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

try {
  # Remove default python stubs created by Microsoft
  Remove-Item $env:USERPROFILE\AppData\Local\Microsoft\WindowsApps\python*.exe

  # Set all python files to use correct python3 install
  VM-Set-Open-With-Association (Get-Command python).Source ".py"

  # Re-add shim path to the top of the path to ensure it is found before Python libraries
  $shimPath = Join-Path $Env:ChocolateyInstall "bin" -Resolve
  [Environment]::SetEnvironmentVariable("Path", "$shimPath;$Env:Path", "Machine")
} catch {
    VM-Write-Log-Exception $_
}
