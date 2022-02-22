$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

try {
  # Path to Notepad++'s configuration file
  $configFile = Join-Path ${Env:APPDATA} "Notepad++\config.xml"

  if (-Not (Test-Path -Path $configFile)) {
    # Launch Notepad++
    Start-Process "notepad++"
    Start-Sleep -Seconds 2

    # Try to gracefully close it so that it can create it's config.xml
    # Give it a little time in case it's slow
    foreach ($item in "0", "1") {
      $notepad = Get-Process -Name "notepad++" -ErrorAction SilentlyContinue
      if ($null -ne $notepad) {
        $notepad | ForEach-Object {$_.CloseMainWindow() | Out-Null}
      }
      Start-Sleep -Seconds 2
    }
  }

  if (-Not (Test-Path -Path $configFile)) {
    VM-Write-Log "WARN" "Can't find config.xml to modify"
  } else {
    # Update the config file and disable auto-updates
    (Get-Content -Path $configFile) -Replace '("noUpdate".*?">)no', '$1yes' | Set-Content -Path $configFile -Force | Out-Null
  }
} catch {
  VM-Write-Log-Exception $_
}
