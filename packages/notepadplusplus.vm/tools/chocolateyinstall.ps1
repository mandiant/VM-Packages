$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

try {
    # Path to Notepad++'s configuration file
    $configFile = Join-Path ${Env:APPDATA} "Notepad++\config.xml"

    if (-Not (Test-Path -Path $configFile)) {
        # Launch Notepad++
        Start-Process "notepad++"

        # Wait for notepad++ to appear
        while ((Get-Process | Where-Object { $_.mainWindowTitle -and $_.name -eq "notepad++" }).Count -eq 0) {
          Start-Sleep -Seconds 1
        }

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

    # Wait for config.xml to exist after notepad++ exits
    $count = 0
    while (-Not (Test-Path -Path $configFile)) {
        Start-Sleep 1
        if ($count++ -eq 10) {
          break
        }
    }

    if (-Not (Test-Path -Path $configFile)) {
        VM-Write-Log "WARN" "Can't find Notepad++'s config.xml to disable auto-updates, skipping..."
    } else {
        # Update the config file and disable auto-updates
        (Get-Content -Path $configFile) -Replace '("noUpdate".*?">)no', '$1yes' | Set-Content -Path $configFile -Force | Out-Null
    }
} catch {
    VM-Write-Log-Exception $_
}

