$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$packageToolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

try {
    # Determine OS Version
    $osVersion = VM-Get-WindowsVersion

    switch ($osVersion) {
        "Win10" { $config = Join-Path $packageToolsDir "win10.xml" }
        "Win11" { $config = Join-Path $packageToolsDir "win11.xml" }
        "Win11ARM" { $config = Join-Path $packageToolsDir "win11arm.xml"}
        default {
            VM-Write-Log "WARN" "Debloater unable to determine debloat config, applying win10.xml"
            $config = Join-Path $packageToolsDir "win10.xml"
        }
    }

    VM-Apply-Configurations $config
    VM-Write-Log "INFO" "Debloating and performance modifications for $osVersion done"

} catch {
    VM-Write-Log-Exception $_
}

