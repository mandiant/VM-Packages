$ErrorActionPreference = 'Continue'
$global:VerbosePreference = "SilentlyContinue"
Import-Module vm.common -Force -DisableNameChecking

try {
    # Gather packages to install
    $installedPackages = (VM-Get-InstalledPackages).Name
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
    try {
        foreach ($package in $packagesToInstall) {
            VM-Write-Host "INFO" "Installing: $package" -ForegroundColor Cyan
            choco install "$package" -y
            VM-Write-Log "INFO" "$package has been installed"
        }
    } catch {
        VM-Write-Log-Exception $_
    }
    VM-Write-Log "INFO" "[+] All packages complete"

    # Set Profile/Version specific configurations
    VM-Write-Log "INFO" "[+] Beginning Windows OS VM profile configuration changes"
    $configFile = Join-Path $Env:VM_COMMON_DIR "config.xml" -Resolve
    VM-Apply-Configurations $configFile

    # Configure PowerShell and cmd prompts
    VM-Configure-Prompts

    # Configure PowerShell Logging
    VM-Configure-PS-Logging

    # Configure Desktop\Tools folder with a custom icon
    if ($iconPath = Join-Path $Env:VM_COMMON_DIR "vm.ico" -Resolve) {
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

    # Remove Chocolatey cache
    $cache = "${Env:LocalAppData}\ChocoCache"
    Remove-Item $cache -Recurse -Force

    # Construct failed packages file path
    $failedPackages = Join-Path $Env:VM_COMMON_DIR "failed_packages.txt"
    $failures = @{}

    # Check and list failed packages from "lib-bad"
    $chocoLibBad = Join-Path ${Env:ProgramData} "chocolatey\lib-bad"
    if ((Test-Path $chocoLibBad) -and (Get-ChildItem -Path $chocoLibBad | Measure-Object).Count -gt 0) {
        Get-ChildItem -Path $chocoLibBad | Foreach-Object {
            $failures[$_.Name] = $true
        }
    }

    # Cross-compare packages to install versus installed packages to find failed packages
    $installedPackages = VM-Get-InstalledPackages
    foreach ($package in $packagesToInstall) {
        if ($installedPackages.Name -notcontains $package) {
            $failures[$package] = $true
        }
    }

    # Write installed packages to log file
    foreach ($package in $installedPackages){
        VM-Write-Log "INFO" "Packages installed:  $($package.Name) | $($package.Version)"
    }
    
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
    }

    # Let users know installation is complete by setting background, playing win sound, and display message box
    # Set background
    Set-ItemProperty 'HKCU:\Control Panel\Colors' -Name Background -Value "0 0 0" -Force | Out-Null
    $backgroundImage = "${Env:VM_COMMON_DIR}\background.png"
    if ((Test-Path $backgroundImage)) {
        # Center: 0, Stretch: 2, Fit:6, Fill: 10, Span: 22
        New-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name WallpaperStyle -PropertyType String -Value 0 -Force | Out-Null
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

    # Show dialog that install has been complete
    Add-Type -AssemblyName System.Windows.Forms
    Add-Type -AssemblyName System.Drawing
    # Create form
    $form = New-Object System.Windows.Forms.Form
    $form.Text = "$Env:MandiantVM Installation Complete"
    $form.TopMost = $true
    $form.StartPosition = [System.Windows.Forms.FormStartPosition]::CenterScreen
    if ($iconPath = Join-Path $Env:VM_COMMON_DIR "vm.ico" -Resolve){
        $form.Icon = New-Object System.Drawing.Icon($iconPath)
    }
    # Create a FlowLayoutPanel
    $flowLayout = New-Object System.Windows.Forms.FlowLayoutPanel
    $flowLayout.FlowDirection = [System.Windows.Forms.FlowDirection]::TopDown
    $flowLayout.Dock = [System.Windows.Forms.DockStyle]::Fill
    $flowLayout.AutoSize = $true
    # Create label
    $label = New-Object System.Windows.Forms.Label
    $label.Text = @"
Install Complete!

Please review %VM_COMMON_DIR%\log.txt for any errors.

For any package related issues, please submit to github.com/mandiant/vm-packages

For any install related issues, please submit to the VM repo

Thank you!
"@
    $label.AutoSize = $true
    $label.Font = New-Object System.Drawing.Font("Microsoft Sans Serif", 10, [System.Drawing.FontStyle]::Regular)
    # Create button
    $button = New-Object System.Windows.Forms.Button
    $button.Text = "Finish"
    $button.DialogResult = [System.Windows.Forms.DialogResult]::OK
    $button.AutoSize = $true
    $button.Font = New-Object System.Drawing.Font("Microsoft Sans Serif", 10, [System.Drawing.FontStyle]::Regular)
    $button.Anchor = [System.Windows.Forms.AnchorStyles]::None
    # Add controls to the FlowLayoutPanel
    $flowLayout.Controls.Add($label)
    $flowLayout.Controls.Add($button)
    # Add the FlowLayoutPanel to the form
    $form.Controls.Add($flowLayout)
    # Auto-size form to fit content
    $form.AutoSize = $true
    $form.AutoSizeMode = [System.Windows.Forms.AutoSizeMode]::GrowAndShrink
    # Show dialog
    $form.ShowDialog()

} catch {
    VM-Write-Log-Exception $_
}

