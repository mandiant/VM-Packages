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
} catch {
    VM-Write-Log-Exception $_
}

