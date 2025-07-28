$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

function Fix-AppxPackageDeployment {
    <#
    .SYNOPSIS
        Applies a temporary fix for AppxPackage deployment issues in Windows 11,
        specifically for installing ttd.vm and windbg.vm.

    .DESCRIPTION
        This function addresses a known issue (as discussed on Reddit:
        https://www.reddit.com/r/PowerShell/comments/1g03x2u/getappxpackage_error_24h2/)
        by adding necessary DLLs to the Global Assembly Cache (GAC).
        It then creates a marker file to indicate the fix has been applied.

    .NOTES
        Requires Administrator privileges to modify system files and the GAC.
        This is a temporary workaround. Always refer to official Microsoft documentation
        for permanent solutions or updates.
    #>
    [CmdletBinding()]
    param()

    Write-Output "Fixing AppxPackage deployment in Windows 11..." -ForegroundColor Yellow

    try {
        # Add the new DLLs to the Global Assembly Cache
        Add-Type -AssemblyName "System.EnterpriseServices"
        $publish = [System.EnterpriseServices.Internal.Publish]::new()

        $dlls = @(
            'System.Memory.dll',
            'System.Numerics.Vectors.dll',
            'System.Runtime.CompilerServices.Unsafe.dll',
            'System.Security.Principal.Windows.dll'
        )

        foreach ($dll in $dlls) {
            $dllPath = Join-Path -Path $env:SystemRoot\System32\WindowsPowerShell\v1.0 -ChildPath $dll
            Write-Output "Attempting to GacInstall: $dllPath" -ForegroundColor Cyan
            $publish.GacInstall($dllPath)
            Write-Output "$dll successfully added to GAC." -ForegroundColor Green
        }

        # Create a file so we can easily track that this computer was fixed (in case we need to revert)
        $markerFilePath = Join-Path -Path $env:SystemRoot\System32\WindowsPowerShell\v1.0 -ChildPath "DllFix.txt"
        New-Item -Path (Split-Path $markerFilePath) -Name (Split-Path $markerFilePath -Leaf) -ItemType File -Value "$dlls added to the Global Assembly Cache" -Force | Out-Null
        Write-Output "Marker file 'DllFix.txt' created at '$markerFilePath'." -ForegroundColor Green

        Write-Output "AppxPackage deployment fix applied successfully." -ForegroundColor Green
    }
    catch {
        Write-Error "An error occurred during the AppxPackage fix: $($_.Exception.Message)"
        Write-Output "Please ensure you run this script with Administrator privileges." -ForegroundColor Red
    }
}

try {
    # Determine OS Version
    $osVersion = VM-Get-WindowsVersion

    $packageToolsDir = $PSScriptRoot
    $packageStartDir = Join-Path $packageToolsDir "start" -Resolve

    switch ($osVersion) {
        "Win10" { $config = Join-Path $packageToolsDir "win10.xml" }
        "Win11" {
            $config = Join-Path $packageToolsDir "win11.xml"
            # Clean up start menu. Cleanest solution possible given lack
            # of relative path and inifinite paths for user download location
            Copy-Item -Path (Join-Path $packageStartDir "start2.bin") -Destination (Join-Path ${Env:UserProfile} "Appdata\Local\Packages\Microsoft.Windows.StartMenuExperienceHost_cw5n1h2txyewy\LocalState\")
            # cover case in older win11 versions where the config file is still start.bin
            Copy-Item -Path (Join-Path $packageStartDir "start2.bin") -Destination (Join-Path ${Env:UserProfile} "Appdata\Local\Packages\Microsoft.Windows.StartMenuExperienceHost_cw5n1h2txyewy\LocalState\start.bin")

            # Call the function to apply the AppxPackage fix for Windows 11
            Fix-AppxPackageDeployment
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