## Run locally to test the packages, similar to .github/workflows/ci.yml

# Built package directory
$built_pkgs_dir = 'built_pkgs'

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
if (-Not (Test-Path $built_pkgs_dir)) { Exit 1 }

# Ask if we should continue install even if a package fails to install
Write-Host -ForegroundColor Yellow -NoNewline "[INFO]: If package fails to uninstall, continue uninstalling other packages? (y/n)"
$keep_uninstalling_response = Read-Host

# Uninstall each package
$built_pkgs = Get-ChildItem $built_pkgs -Recurse -Include *.nupkg | Foreach-Object {( [regex]::match($_.BaseName, '(.*?[.](?:vm)).*').Groups[1].Value)}
foreach ($package in $built_pkgs) {
  # Skip this package since it is a dependency for most packages
  if ($package -contains "common.vm") {
    continue
  }

  choco uninstall $package -y
  if ($validExitCodes -notcontains $LASTEXITCODE) {
    if ($keep_uninstalling_response -ne 'y') {
      Write-Host -ForegroundColor Red -NoNewline "[WARN]: Uninstall failed. Continue uninstalling other packages? (y/n)"
      $response = Read-Host
      if ($response -ne 'y') {
        Write-Host -ForegroundColor Red "[*] Exiting..."
        Exit 1
      }
    }
  }
}

# Ask if "common.vm" should explicitly be uninstalled
Write-Host -ForegroundColor Yellow -NoNewline "[INFO]: Uninstall common.vm package? (y/n)"
$response = Read-Host
if ($response -eq 'y') {
  choco uninstall "common.vm" -y
}