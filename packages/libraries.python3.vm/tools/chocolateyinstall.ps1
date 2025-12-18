$ErrorActionPreference = 'Continue'
Import-Module vm.common -Force -DisableNameChecking

try {
    $toolDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
    $modulesPath = Join-Path $toolDir "modules.xml" -Resolve
    $modulesXml = [xml](Get-Content $modulesPath)

    # Fix pip version
    VM-Pip-Install "pip~=23.2.1"

    $failures = @()
    $pipArgs = @()
    $modules = $modulesXml.modules.module

    Write-Host "Attempting to install the following Python3 modules:"
    foreach ($module in $modules) {
        Write-Host "[+] $($module.name)"
        $installValue = $module.name
        if ($module.url) {
            $installValue = $module.url
        }
        $pipArgs += $installValue
    }

    Write-Host "Batch installing Python modules..."
    $batchInstallString = $pipArgs -join " "
    VM-Pip-Install $batchInstallString

    foreach ($module in $modules) {
        $pkgName = $module.name

        # Clean up version pins (e.g., "pywin32==308" -> "pywin32") for install check
        if ($pkgName -match "==") {
            $pkgName = $pkgName -split "==" | Select-Object -First 1
        }
        if ($pkgName -match ">=") {
            $pkgName = $pkgName -split ">=" | Select-Object -First 1
        }

        # 'pip show' returns exit code 0 if found, 1 if missing
        $null = py -3.10 -m pip show $pkgName 2>&1

        if ($LASTEXITCODE -ne 0) {
            Write-Host "`t[!] Failed to install Python 3.10 module:$pkgName" -ForegroundColor Red
            $failures += $pkgName
        } else {
            Write-Host "`t[+] Installed Python 3.10 module: $pkgName" -ForegroundColor Green
        }
    }

    if ($failures.Count -gt 0) {
        foreach ($module in $failures) {
            VM-Write-Log "ERROR" "Failed to install Python 3.10 module: $module"
        }
        throw "Package installation failed. The following modules could not be verified: $($failures -join ', ')"
    }

    # Fix issue with chocolately printing incorrect install directory
    $pythonPath = py -3.10 -c "import sys; print(sys.prefix)" 2>$null
    if ($pythonPath) {
        $env:ChocolateyPackageInstallLocation = $pythonPath
    }

    # Avoid WARNINGs to fail the package install
    exit 0
} catch {
    VM-Write-Log-Exception $_
}
