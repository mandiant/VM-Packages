# Build the packages in the 'packages' directory given as argument (or all if none provided) into the 'built_pkgs'.
# Install the built packages

# Examples
## ./test_install
## ./test_install '7zip.vm 010editor.vm'

param ([string] $package_names=$null)

# Error Code Definitions
# ----------------------
# 0: operation was successful, no issues detected
# 1605: software is not installed
# 1614: product is uninstalled
# 1641: success, reboot initiated
# 3010: success, reboot required
# other (not listed): likely an error has occurred
$validExitCodes = @(0, 1605, 1614, 1641, 3010)
$packages_dir_name = 'packages'
$built_pkgs_dir_name = 'built_pkgs'


$root = Get-Location
$built_pkgs_dir = New-Item -ItemType Directory -Force $built_pkgs_dir_name

if ($package_names) {
    $packages = $package_names.Split(" ")
} else {
    $packages = Get-ChildItem -Path $packages_dir_name | Select-Object -ExpandProperty Name
}

foreach ($package in $packages) {
    Set-Location "$root\$packages_dir_name\$package"
    choco pack -out $built_pkgs_dir
    if ($LASTEXITCODE -ne 0) { Exit 1 } # Abort with the first failing build
}


$exclude_tests = @("flarevm.installer.vm")
$built_pkgs = Get-ChildItem $built_pkgs_dir | Foreach-Object { ([regex]::match($_.BaseName, '(.*?[.](?:vm)).*').Groups[1].Value) } | Where-Object { $_ -notin $exclude_tests }
Set-Location $built_pkgs_dir
foreach ($package in $built_pkgs) {
    choco install $package -y -s "'.;https://www.myget.org/F/vm-packages/api/v2;https://community.chocolatey.org/api/v2/'" --no-progress --force
    if ($validExitCodes -notcontains $LASTEXITCODE) { # Abort with the first failing install
        Write-Host -ForegroundColor Red "[ERROR] Failed to install $package"
        # Restore the original location
        Set-Location -Path $org_dir -PassThru | Out-Null
        Exit 1
    }
}

# Restore the original location
Set-Location -Path $root -PassThru | Out-Null

