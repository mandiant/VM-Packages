$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

try {
  # Re-add shim path to the top of the path to ensure it is found before Python libraries
  $shimPath = Join-Path $Env:ChocolateyInstall "bin" -Resolve
  [Environment]::SetEnvironmentVariable("Path", "$shimPath;$Env:Path", "Machine")
} catch {
    VM-Write-Log-Exception $_
}

