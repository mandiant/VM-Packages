# Build the packages in the 'packages' directory given as argument (or all if none provided) into the 'built_pkgs'.
# Install the built packages. If a package install fails and the $all switch is not provided,
# the rest of the packages are not installed

# Examples
## ./test_install
## ./test_install '7zip.vm 010editor.vm'
## ./test_install -all

param ([string] $package_names=$null, [int] $max_tries=2, [switch] $all)

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
$result_file = "success_failure.json"


$root = Get-Location
$built_pkgs_dir = New-Item -ItemType Directory -Force $built_pkgs_dir_name

if ($package_names) {
    $packages = $package_names.Split(" ")
} else {
    $packages = Get-ChildItem -Path $packages_dir_name | Select-Object -ExpandProperty Name
}

foreach ($package in $packages) {
    Set-Location "$root\$packages_dir_name\$package"
    choco pack -y -out $built_pkgs_dir
    if ($LASTEXITCODE -ne 0) { Exit 1 } # Abort with the first failing build
}


$exclude_tests = @("flarevm.installer.vm", "python3.vm")

$failures = New-Object Collections.Generic.List[string]
$failed = 0
$success = 0

$built_pkgs = Get-ChildItem $built_pkgs_dir | Foreach-Object { ([regex]::match($_.BaseName, '(.*?[.](?:vm)).*').Groups[1].Value) } | Where-Object { $_ -notin $exclude_tests }
Set-Location $built_pkgs_dir
foreach ($package in $built_pkgs) {
    # We try to install the package several times (with a minute interval) to prevent transient failures
    for ($tries = 1; $tries -le $max_tries; $tries += 1) {
        # install looks for a nuspec with the same version as the installed one
        # upgrade installs the last found version (even if the package is not installed)
        choco upgrade $package -y -r -s "'.;https://www.myget.org/F/vm-packages/api/v2;https://community.chocolatey.org/api/v2/'" --no-progress --force
        if ($validExitCodes -contains $LASTEXITCODE) {
            $success += 1
            break
        } elseif ($tries -lt $max_tries) {
            Write-Host -ForegroundColor Yellow "[WARN] Failed to install $package - Try $tries"
            Start-Sleep -Seconds 60
        } else {
            Write-Host -ForegroundColor Red "[ERROR] Failed to install $package - Try $tries"
            $failed += 1
            $failures.Add("`"$package`"")
            if (-not $all.IsPresent) { break } # Abort with the first failing install
        }
    }
}

# Restore the original location
Set-Location -Path $root -PassThru | Out-Null

Write-Host -ForegroundColor Green "`nSUCCESS:$success"
Write-Host -ForegroundColor Red "FAILURE:$failed"

Write-Host "`nWriting success/failure/total and failing packages to $result_file"
$failures_str = $failures -join ","
"{`"success`":$success,`"failure`":$failed,`"total`":$($packages.Count),`"failures`":[$failures_str]}" | Out-File -FilePath $result_file

if ($failed){ Exit 1 }
# Return 0 to avoid valid exit codes to fail the test
Exit 0
