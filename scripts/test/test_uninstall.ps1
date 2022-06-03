# Uninstall all packages in 'built_pkgs'

# Error Code Definitions
# ----------------------
# 0: operation was successful, no issues detected
# 1605: software is not installed
# 1614: product is uninstalled
# 1641: success, reboot initiated
# 3010: success, reboot required
# other (not listed): likely an error has occurred
$validExitCodes = @(0, 1605, 1614, 1641, 3010)
$built_pkgs_dir_name = 'built_pkgs'


$root = Get-Location
$built_pkgs_dir = New-Item -ItemType Directory -Force $built_pkgs_dir_name

$built_pkgs = Get-ChildItem $built_pkgs_dir | Foreach-Object {( [regex]::match($_.BaseName, '(.*?[.](?:vm)).*').Groups[1].Value)}
Set-Location $built_pkgs_dir
foreach ($package in $built_pkgs) {
    if ($package -contains "common.vm") {
        continue
    }

    choco uninstall $package -y
    if ($validExitCodes -notcontains $LASTEXITCODE) {
        Write-Host -ForegroundColor Red -NoNewline "[WARN]: Failed to uninstall $package"
        Exit 1
    }
}

# Ask if "common.vm" should explicitly be uninstalled
Write-Host -ForegroundColor Yellow -NoNewline "[INFO]: Uninstall common.vm package? (y/n)"
$response = Read-Host
if ($response -eq 'y') {
    choco uninstall "common.vm" -y
}

# Restore the original location
Set-Location -Path $root -PassThru | Out-Null

