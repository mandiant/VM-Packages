$ErrorActionPreference = 'Continue'
$global:VerbosePreference = "SilentlyContinue"
Import-Module vm.common -Force -DisableNameChecking

# Get the names of the packages that failed to install as an array of strings
function Get-Failed-Packages() {
    $failedPackages = @{}

    # Check and list failed packages from "lib-bad"
    $chocoLibBad = Join-Path ${Env:ProgramData} "chocolatey\lib-bad"
    if ((Test-Path $chocoLibBad) -and (Get-ChildItem -Path $chocoLibBad | Measure-Object).Count -gt 0) {
        Get-ChildItem -Path $chocoLibBad | Foreach-Object {
            $failedPackages[$_.Name] = $true
        }
    }

    # Cross-compare packages to install versus installed packages to find failed packages
    $installedPackages = VM-Get-InstalledPackages
    foreach ($package in $packagesToInstall) {
        if ($installedPackages.Name -notcontains $package) {
            $failedPackages[$package] = $true
        }
    }

    [string[]] $failedPackages.Keys
}

# Install the packages provided as parameter, displaying log information
function Install-Packages([object] $packagesToInstall) {
    try {
        foreach ($package in $packagesToInstall) {
            VM-Write-Log "INFO" "Installing: $package"
            choco install "$package" -y
            if ($LASTEXITCODE) {
              VM-Write-Log "ERROR" "`t$package has not been installed"
            } else {
              VM-Write-Log "INFO" "`t$package has been installed"
            }
        }
    } catch {
        VM-Write-Log-Exception $_
    }
}

function Fix-WebThreatDefSvcPermissions {
    <#
    .SYNOPSIS
    Takes ownership of and grants full control to Administrators for the C:\Windows\System32\WebThreatDefSvc directory.

    .DESCRIPTION
    This function executes two command-line utilities: 'takeown' and 'icacls'.
    It first takes ownership of the specified directory (and its subfolders/files)
    and then grants the 'Administrators' group full control over it.
    This is used to resolve "Access to the path 'C:\Windows\System32\WebThreatDefSvc' is denied" errors.

    .NOTES
    Requires elevated (Administrator) privileges to run successfully.
    #>
    [CmdletBinding()]
    Param()

    $targetPath = "C:\Windows\System32\WebThreatDefSvc"

    VM-Write-Log "INFO" "Attempting to fix permissions for: $targetPath"

    if (-not (Test-Path -Path $targetPath -PathType Container)) {
        VM-Write-Log "INFO" "'$targetPath' does not exist."
        return
    }

    # Check for Administrator privileges
    if (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
        VM-Write-Log "ERROR" "This function must be run with Administrator privileges. Please run PowerShell as Administrator."
        return
    }

    try {
        VM-Write-Log "INFO" "Fixing WebThreatDefSvc permissions: 1. Take ownership of '$targetPath'..."
        # /f: specifies file or directory
        # /r: performs recursive operation on all files and subfolders
        # /d y: suppresses prompt for confirmation when taking ownership of subdirectories
        $takeownOutput = cmd.exe /c "takeown /f `"$targetPath`" /r /d y" 2>&1
        if ($LASTEXITCODE) {
            VM-Write-Log "WARN" "takeown command failed with exit code: $LASTEXITCODE"
            if ($takeownOutput) {
                VM-Write-Log "INFO" $takeownOutput
            }
        } else {
            VM-Write-Log "INFO" "Ownership taken successfully."
        }

        VM-Write-Log "INFO" "Fixing WebThreatDefSvc permissions: 2. Grant full control to 'Administrators' for '$targetPath'..."
        # /grant Administrators:F: Grants full control (F) to the Administrators group
        # /T: Performs recursive operation on all files and subfolders
        # /C: Continues on file errors (important for robustness)
        # /Q: Suppresses success messages
        $icaclsOutput = cmd.exe /c "icacls `"$targetPath`" /grant Administrators:F /T /C /Q" 2>&1
        if ($LASTEXITCODE) {
            VM-Write-Log "WARN" "icacls command failed with exit code: $LASTEXITCODE"
            if ($icaclsOutput) {
                VM-Write-Log "INFO" $icaclsOutput
            }
        } else {
            VM-Write-Log "INFO" "Full control granted to Administrators successfully."
        }
    }
    catch {
        VM-Write-Log "ERROR" "Failed to apply WebThreatDefSvc permission fix: $_`n$($_.InvocationInfo.PositionMessage)"
    }
}

try {
    $osVersion = VM-Get-WindowsVersion
    if ($osVersion -eq "Win11" -or $osVersion -eq "Win11ARM") {
        Fix-WebThreatDefSvcPermissions
    }

    $installedPackages = VM-Get-InstalledPackages
    $configPath = Join-Path ${Env:VM_COMMON_DIR} "packages.xml" -Resolve
    $configXml = [xml](Get-Content $configPath)
    $packagesToInstall = $configXml.config.packages.package.name | Where-Object { $installedPackages -notcontains $_ }

    # List packages to install
    Write-Host "[+] Packages to install:"
    foreach ($package in $packagesToInstall) {
        Write-Host "`t[+] $package"
    }
    Start-Sleep 1

    # Install the packages
    Install-Packages($packagesToInstall)

    # Re-install failed packages
    $failedPackages = Get-Failed-Packages
    if ($failedPackages) {
      VM-Write-Log "WARN" "`nReinstalling failed packages: $failedPackages`n"
      Install-Packages($failedPackages)
    }

    VM-Write-Log "INFO" "Packages installation complete"

    # Set Profile/Version specific configurations
    VM-Write-Log "INFO" "Beginning Windows OS VM profile configuration changes"
    $configPath = Join-Path $Env:VM_COMMON_DIR "config.xml" -Resolve
    VM-Apply-Configurations $configPath

    # Configure PowerShell and cmd prompts
    VM-Configure-Prompts

    # Configure PowerShell Logging
    VM-Configure-PS-Logging

    # Configure Desktop\Tools folder with a custom icon if it exists
    $iconPath = Join-Path $Env:VM_COMMON_DIR "vm.ico"
    if (Test-Path $iconPath) {
        $folderPath = $Env:TOOL_LIST_DIR
        # Set the icon
        if (Test-Path -Path $folderPath -PathType Container) {
            # Full path to the desktop.ini file inside the folder
            $desktopIniPath = Join-Path -Path $folderPath -ChildPath 'desktop.ini'

            # Check if desktop.ini already exists
            if (-Not (Test-Path -Path $desktopIniPath)) {
                    # Create an empty desktop.ini if it doesn't exist
                    Set-Content -Path $desktopIniPath -Value ''
                }

                # Make the folder "system" to enable custom settings like icon change
                Start-Process "attrib" -ArgumentList "+s $folderPath" -Wait

                # Write the needed settings into desktop.ini
                Add-Content -Path $desktopIniPath -Value "[.ShellClassInfo]"
                Add-Content -Path $desktopIniPath -Value ("IconResource=$iconPath,0")

                # Make the desktop.ini file hidden and system
                Start-Process "attrib" -ArgumentList " +h +s $desktopIniPath" -Wait
            }
    }

    # Refresh the desktop
    VM-Refresh-Desktop

    # Remove Chocolatey cache folder
    $cache = "${Env:LocalAppData}\ChocoCache"
    Remove-Item $cache -Recurse -Force

    # Write installed packages to log file
    foreach ($package in $installedPackages){
        VM-Write-Log "INFO" "Package installed:  $($package.Name) | $($package.Version)"
    }

    # Write failed packages to file. Always create this file even if there are no failed packages,
    # as we use it in FLARE-VM unattended installation to check if the installation has finished.
    $failedPackagesFile = Join-Path $Env:VM_COMMON_DIR "failed_packages.txt"
    New-Item $failedPackagesFile

    $failedPackages = Get-Failed-Packages
    if ($failedPackages) {
        foreach ($package in $failedPackages) {
            VM-Write-Log "ERROR" "Failed to install: $package"
            Add-Content $failedPackagesFile $package
        }

        VM-Write-Log "ERROR" "For each failed package, you may attempt a manual install via: choco install -y <package_name>"
        VM-Write-Log "ERROR" "Failed package list saved to: $failedPackages"
        VM-Write-Log "ERROR" "Please check the following logs for additional errors:"
        VM-Write-Log "ERROR" "`t$logPath (this file)"
        VM-Write-Log "ERROR" "`t%PROGRAMDATA%\chocolatey\logs\chocolatey.log"
        VM-Write-Log "ERROR" "`t%LOCALAPPDATA%\Boxstarter\boxstarter.log"
    }

    # Display installer log if available
    $logPath = Join-Path ${Env:VM_COMMON_DIR} "log.txt"
    if ((Test-Path $logPath)) {
        Write-Host "[-] Please check the following logs for any errors:" -ForegroundColor Yellow
        Write-Host "`t[-] $logPath" -ForegroundColor Yellow
        Write-Host "`t[-] %PROGRAMDATA%\chocolatey\logs\chocolatey.log" -ForegroundColor Yellow
        Write-Host "`t[-] %LOCALAPPDATA%\Boxstarter\boxstarter.log" -ForegroundColor Yellow
        Start-Sleep 5
        & notepad.exe $logPath
    }

    # Let users know installation is complete by setting lock screen & wallpaper background, playing win sound, and display message box

    # Set lock screen image
    $lockScreenImage = "${Env:VM_COMMON_DIR}\lockscreen.png"
    if ((Test-Path $lockScreenImage)) {
        New-Item "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\PersonalizationCSP" -Force | Out-Null
        New-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\PersonalizationCSP" -Name LockScreenImagePath -PropertyType String -Value $lockScreenImage -Force | Out-Null
        New-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\PersonalizationCSP" -Name LockScreenImageStatus -PropertyType DWord -Value 1 -Force | Out-Null
    }

    # Set wallpaper
    Set-ItemProperty 'HKCU:\Control Panel\Colors' -Name Background -Value "0 0 0" -Force | Out-Null
    $backgroundImage = "${Env:VM_COMMON_DIR}\background.png"
    if ((Test-Path $backgroundImage)) {
        # WallpaperStyle - Center: 0, Stretch: 2, Fit:6, Fill: 10, Span: 22
        Add-Type -AssemblyName System.Drawing
        $img = [System.Drawing.Image]::FromFile($backgroundImage);
        $wallpaperStyle = if ($img.Width/$img.Height -ge 16/9) { 6 } else { 0 }
        New-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name WallpaperStyle -PropertyType String -Value $wallpaperStyle -Force | Out-Null
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

    # Play sound
    try {
        $playWav = New-Object System.Media.SoundPlayer
        $playWav.SoundLocation = 'https://www.winhistory.de/more/winstart/down/owin31.wav'
        $playWav.PlaySync()
    } catch {
        VM-Write-Log-Exception $_
    }

    VM-Write-Log "INFO" "[*] Install Complete!"
    VM-Write-Log "INFO" "[*] Please review %VM_COMMON_DIR%\log.txt for any errors."
    VM-Write-Log "INFO" "[*] For any package related issues, please submit to github.com/mandiant/vm-packages"
    VM-Write-Log "INFO" "[*] For any install related issues, please submit to the VM repo"
    VM-Write-Log "INFO" "[*] Thank you!"

} catch {
    VM-Write-Log-Exception $_
}

