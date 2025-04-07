$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$packageToolsDir = Join-Path $(Get-Location) "debloat.vm\tools"
$packageStartDir = Join-Path $(Get-Location) "debloat.vm\start"

try {
    # Determine OS Version
    $osVersion = VM-Get-WindowsVersion

    switch ($osVersion) {
        "Win10" { $config = Join-Path $packageToolsDir "win10.xml" }
        "Win11" {
            $config = Join-Path $packageToolsDir "win11.xml"
            # Clean up start menu. Cleanest solution possible given lack
            # of relative path and inifinite paths for user download location
            Copy-Item -Path (Join-Path $packageStartDir "start2.bin") -Destination (Join-Path ${Env:UserProfile} "Appdata\Local\Packages\Microsoft.Windows.StartMenuExperienceHost_cw5n1h2txyewy\LocalState\")
            # cover case in older win11 versions where the config file is still start.bin
            Copy-Item -Path (Join-Path $packageStartDir "start2.bin") -Destination (Join-Path ${Env:UserProfile} "Appdata\Local\Packages\Microsoft.Windows.StartMenuExperienceHost_cw5n1h2txyewy\LocalState\start.bin")

        }
        "Win11ARM" {
            $config = Join-Path $packageToolsDir "win11arm.xml"
            Copy-Item -Path (Join-Path $packageStartDir "start2.bin") -Destination (Join-Path ${Env:UserProfile} "Appdata\Local\Packages\Microsoft.Windows.StartMenuExperienceHost_cw5n1h2txyewy\LocalState\")
            Copy-Item -Path (Join-Path $packageStartDir "start2.bin") -Destination (Join-Path ${Env:UserProfile} "Appdata\Local\Packages\Microsoft.Windows.StartMenuExperienceHost_cw5n1h2txyewy\LocalState\start.bin")

        }
        default {
            Write-Output "WARN" "Debloater unable to determine debloat config, applying win10.xml"
            $config = Join-Path $packageToolsDir "win10.xml"
        }
    }
    Write-Output "Applying $config"
    VM-Apply-Configurations $config
    Write-Output "INFO" "Debloating and performance modifications for $osVersion done"

}
catch {
    VM-Write-Log-Exception $_
}

