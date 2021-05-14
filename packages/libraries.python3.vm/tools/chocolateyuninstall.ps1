$ErrorActionPreference = 'Continue'
Import-Module vm.common -Force -DisableNameChecking

function LoadPackages {
  try {
    $json = Get-Content $pkgPath -ErrorAction Stop
    $packages = VM-ConvertFrom-Json $json
  } catch {
    return $null
  }
  return $packages
}

function UninstallOneModule {
  param([string] $name)
  iex "py -3 -m pip uninstall -y $name 2>&1 >> $outputFile"
  return $LastExitCode
}

$toolDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$pkgPath = Join-Path $toolDir "packages.json"

$json = LoadPackages $pkgPath
if (($null -eq $json) -Or ($null -eq $json.packages)) {
  Write-Host "Error loading packages! Exiting"
  Exit 1
}

# Create output file to log python module installation details
$outputFile = VM-New-Install-Log $toolDir

# upgrade pip
iex "py -3 -m pip install --no-cache-dir --upgrade pip 2>&1 >> $outputFile"

$packages = $json.packages
$success = $true
foreach ($pkg in $packages) {
  $name = $pkg.name
  Write-Host "Trying to uninstall $name"
  if ((UninstallOneModule $name) -eq 0) {
    Write-Host "Uninstalled $name"
  } else {
    VM-Write-Log "ERROR" "Failed to uninstall $name"
    $success = $false
  }
}

if ($success -eq $false) {
  Write-Host "Failed to uninstall at least one Python module"
  VM-Write-Log "ERROR" "Check $outputFile for more information"
  Exit 1
} else {
  Remove-Item -Path $outputFile -Force | Out-Null
}
