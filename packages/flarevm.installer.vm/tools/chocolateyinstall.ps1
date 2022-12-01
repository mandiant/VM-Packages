$ErrorActionPreference = 'Continue'
$global:VerbosePreference = "SilentlyContinue"
Import-Module vm.common -Force -DisableNameChecking

function Get-InstalledPackages {
    if (Get-Command clist -ErrorAction:SilentlyContinue) {
        chocolatey list -l -r -all | ForEach-Object {
            $Name, $Version = $_ -split '\|'
            New-Object -TypeName psobject -Property @{
                'Name' = $Name
                'Version' = $Version
            }
        }
    }
}

try {
    # Gather packages to install
    $installedPackages = (Get-InstalledPackages).Name
    $configPath = Join-Path ${Env:VM_COMMON_DIR} "config.xml" -Resolve
    $configXml = [xml](Get-Content $configPath)
    $packagesToInstall = $configXml.config.packages.package.name | Where-Object { $installedPackages -notcontains $_ }

    # List packages to install
    Write-Host "[+] Packages to install:"
    foreach ($package in $packagesToInstall) {
        Write-Host "`t[+] $package"
    }
    Start-Sleep 1

    # Install the packages
    foreach ($package in $packagesToInstall) {
        Write-Host "[+] Installing: $package" -ForegroundColor Cyan
        choco install "$package" -y
    }
    Write-Host "[+] Installation complete" -ForegroundColor Green

    # Remove Chocolatey cache
    $cache = "${Env:LocalAppData}\ChocoCache"
    Remove-Item $cache -Recurse -Force

    # Construct failed packages file path
    $desktopPath = [Environment]::GetFolderPath("Desktop")
    $failedPackages = Join-Path $desktopPath "failed_packages.txt"
    $failures = @{}

    # Check and list failed packages from "lib-bad"
    $chocoLibBad = Join-Path ${Env:ProgramData} "chocolatey\lib-bad"
    if ((Test-Path $chocoLibBad) -and (Get-ChildItem -Path $chocoLibBad | Measure-Object).Count -gt 0) {
        Get-ChildItem -Path $chocoLibBad | Foreach-Object {
            $failures[$_.Name] = $true
        }
    }

    # Cross-compare packages to install versus installed packages to find failed packages
    $installedPackages = (Get-InstalledPackages).Name
    foreach ($package in $packagesToInstall) {
        if ($installedPackages -notcontains $package) {
            $failures[$package] = $true
        }
    }

    $installedPackages = chocolatey list -l -r -all | Out-String
    VM-Write-Log "INFO" "Packages installed:`n$installedPackages"

    # Write each failed package to failure file
    foreach ($package in $failures.Keys) {
        VM-Write-Log "ERROR" "Failed to install: $package"
        Add-Content $failedPackages $package
    }

    # Log additional info if we found failed packages
    $logPath = Join-Path ${Env:VM_COMMON_DIR} "log.txt"
    if ((Test-Path $failedPackages)) {
        VM-Write-Log "ERROR" "For each failed package, you may attempt a manual install via: choco install -y <package_name>"
        VM-Write-Log "ERROR" "Failed package list saved to: $failedPackages"
        VM-Write-Log "ERROR" "Please check the following logs for additional errors:"
        VM-Write-Log "ERROR" "`t$logPath (this file)"
        VM-Write-Log "ERROR" "`t%PROGRAMDATA%\chocolatey\logs\chocolatey.log"
        VM-Write-Log "ERROR" "`t%LOCALAPPDATA%\Boxstarter\boxstarter.log"
    }

    # Display installer log if available
    if ((Test-Path $logPath)) {
        Write-Host "[-] Please check the following logs for any errors:" -ForegroundColor Yellow
        Write-Host "`t[-] $logPath" -ForegroundColor Yellow
        Write-Host "`t[-] %PROGRAMDATA%\chocolatey\logs\chocolatey.log" -ForegroundColor Yellow
        Write-Host "`t[-] %LOCALAPPDATA%\Boxstarter\boxstarter.log" -ForegroundColor Yellow
        Start-Sleep 5
        & notepad.exe $logPath
    }

    # Let users know installation is complete by setting background, playing win sound, and display message box
    Set-ItemProperty 'HKCU:\Control Panel\Colors' -Name Background -Value "0 0 0" -Force | Out-Null
    $backgroundImage = "${Env:VM_COMMON_DIR}\background.png"
    if ((Test-Path $backgroundImage)) {
        # Center: 0, Stretch: 2, Fit:6, Fill: 10, Span: 22
        New-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name WallpaperStyle -PropertyType String -Value 6 -Force | Out-Null
        New-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name TileWallpaper -PropertyType String -Value 0 -Force | Out-Null
        Add-Type -TypeDefinition @"
using System;
using System.Runtime.InteropServices;

public class VMBackground
{
    [DllImport("User32.dll",CharSet=CharSet.Unicode)]
    public static extern int SystemParametersInfo (Int32 uAction, Int32 uParam, String lpvParam, Int32 fuWinIni);
    [DllImport("User32.dll",CharSet=CharSet.Unicode)]
    public static extern bool SetSysColors(int cElements, int[] lpaElements, int[] lpaRgbValues);
}
"@
        [VMBackground]::SystemParametersInfo(20, 0, $backgroundImage, 3)
        [VMBackground]::SetSysColors(1, @(1), @(0x000000))
    }

    $playWav = New-Object System.Media.SoundPlayer
    $playWav.SoundLocation = 'https://www.winhistory.de/more/winstart/down/owin31.wav'
    $playWav.PlaySync()

    Add-Type -AssemblyName PresentationCore,PresentationFramework
    $msgBody = "Install complete!`nPlease review %VM_COMMON_DIR%\log.txt for any errors.`nThank you"
    $msgTitle = "VM Installation Complete"
    $msgButton = 'OK'
    $msgImage = 'Asterisk'
    [System.Windows.MessageBox]::Show($msgBody,$msgTitle,$msgButton,$msgImage)
} catch {
    VM-Write-Log-Exception $_
}

