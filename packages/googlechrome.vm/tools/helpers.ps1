# https://github.com/actions/runner-images/blob/6130ddb3c3914dd466c71a4606cbf7e2697e0a02/images/windows/scripts/build/Install-Chrome.ps1#L11
function Disable-Chrome-Updates {
    # Prepare firewall rules
    # Write-Host "Adding the firewall rule for Google update blocking..."
    New-NetFirewallRule -DisplayName "BlockGoogleUpdate" -Direction Outbound -Action Block -Program "C:\Program Files (x86)\Google\Update\GoogleUpdate.exe" | Out-Null

    $googleServices = @('gupdate', 'gupdatem') | Get-Service
    Stop-Service $googleServices
    $googleServices.WaitForStatus('Stopped', "00:01:00")
    $googleServices | Set-Service -StartupType Disabled | Out-Null

    $regGoogleUpdatePath = "HKLM:\SOFTWARE\Policies\Google\Update"
    $regGoogleUpdateChrome = "HKLM:\SOFTWARE\Policies\Google\Chrome"
    ($regGoogleUpdatePath, $regGoogleUpdateChrome) | ForEach-Object {
        New-Item -Path $_ -Force | Out-Null
    }

    $regGoogleParameters = @(
        @{ Name = "AutoUpdateCheckPeriodMinutes"; Value = 00000000},
        @{ Name = "UpdateDefault"; Value = 00000000 },
        @{ Name = "DisableAutoUpdateChecksCheckboxValue"; Value = 00000001 },
        @{ Name = "Update{8A69D345-D564-463C-AFF1-A69D9E530F96}"; Value = 00000000 },
        @{ Path = $regGoogleUpdateChrome; Name = "DefaultBrowserSettingEnabled"; Value = 00000000 }
    )

    $regGoogleParameters | ForEach-Object {
        $Arguments = $_
        if (-not ($Arguments.Path)) {
            $Arguments.Add("Path", $regGoogleUpdatePath)
        }
        $Arguments.Add("Force", $true)
        New-ItemProperty @Arguments | Out-Null
    }

}

# https://github.com/chocolatey-community/chocolatey-packages/blob/master/extensions/chocolatey-core.extension/extensions/Get-PackageCacheLocation.ps1
function Get-PackageCacheLocation {
    $name = $Env:ChocolateyPackageName
    $ver  = $Env:ChocolateyPackageVersion

    if (!$name) { VM-Write-Log 'WARN' 'Environment variable $Env:ChocolateyPackageName is not set' }

    $res = Join-Path $Env:TEMP $Name

    if (!$ver) { VM-Write-Log 'WARN' 'Environment variable $Env:ChocolateyPackageVersion is not set' }

    $res = Join-Path $res $ver

    $res
}
