## Run locally to test the packages, similar to .github/workflows/ci.yml

# Save original location
$org_dir = Get-Location

# Packages directory (e.g. the packages folder in the current directory)
$packages_dir = 'packages'

# Error Code Definitions
# ----------------------
# 0: operation was successful, no issues detected
# 1605: software is not installed
# 1614: product is uninstalled
# 1641: success, reboot initiated
# 3010: success, reboot required
# other (not listed): likely an error has occurred
$validExitCodes = @(0, 1605, 1614, 1641, 3010)

# Ensure packages directory exists
if (-Not (Test-Path $packages_dir)) { Exit 1 }

# Create built packages directory and enumerate package directories
$built_pkgs_dir = New-Item -Force -ItemType Directory 'built_pkgs'
$package_dirs = Get-ChildItem -Path $packages_dir | % { $_.FullName }

# Ask if packages should be built
Write-Host -ForegroundColor Yellow -NoNewline "[INFO]: Build all packages? (y/n)"
$response = Read-Host
if ($response -eq 'y') {
  # Build each package
  foreach ($package_dir in $package_dirs) {
      Set-Location $package_dir
      choco pack -out $built_pkgs_dir
      if ($LASTEXITCODE -ne 0) {
        # Abort with the first failing build
        Set-Location -Path $org_dir -PassThru | Out-Null
        Exit 1
      }
  }
}

# Change to built package directory
Set-Location $built_pkgs_dir

# Ask if "common.vm" should explicitly be installed first
Write-Host -ForegroundColor Yellow -NoNewline "[INFO]: Install common.vm package? (y/n)"
$response = Read-Host
if ($response -eq 'y') {
  choco upgrade "common.vm" -force -y -s "'.;https://community.chocolatey.org/api/v2/'"
}

# Ask if we should continue install even if a package fails to install
Write-Host -ForegroundColor Yellow -NoNewline "[INFO]: If package fails to install, continue installing other packages? (y/n)"
$keep_installing_response = Read-Host

# Install each package
$built_pkgs = Get-ChildItem $built_pkgs -Recurse -Include *.nupkg | Foreach-Object {( [regex]::match($_.BaseName, '(.*?[.](?:vm)).*').Groups[1].Value)}
foreach ($package in $built_pkgs) {
  if ($package -LIKE "common.vm") {
    continue
  }
  choco upgrade $package -force -y -s "'.;https://community.chocolatey.org/api/v2/'"
  if ($validExitCodes -notcontains $LASTEXITCODE) {
    if ($keep_installing_response -ne 'y') {
      Write-Host -ForegroundColor Red -NoNewline "[WARN]: Install failed. Continue installing other packages? (y/n)"
      $response = Read-Host
      if ($response -ne 'y') {
        Set-Location -Path $org_dir -PassThru | Out-Null
        Write-Host -ForegroundColor Red "[*] Exiting..."
        Exit 1
      }
    }
  }
}

# Restore the original location
Set-Location -Path $org_dir -PassThru | Out-Null