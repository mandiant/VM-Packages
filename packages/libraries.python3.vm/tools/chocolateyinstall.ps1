$ErrorActionPreference = 'Continue'
Import-Module vm.common -Force -DisableNameChecking

try {
    $toolDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
    $modulesPath = Join-Path $toolDir "modules.xml" -Resolve
    $modulesXml = [xml](Get-Content $modulesPath)

    # Create output file to log python module installation details
    $outputFile = VM-New-Install-Log ${Env:VM_COMMON_DIR}

    # Fix pip version (Use --no-deps to prevent crashing on existing environment conflicts)
    Write-Host "[+] Enforcing pip version..."
    $pipVersion = "pip~=23.2.1"
    Invoke-Expression "py -3.13 -W ignore -m pip install $pipVersion --disable-pip-version-check --no-deps --force-reinstall 2>&1 >> $outputFile"

    $failures = @()
    $modules = $modulesXml.modules.module

    Write-Host "Installing Python 3.13 modules..."
    # Process each module one by one to isolate failures
    foreach ($module in $modules) {
        $installValue = if ($module.url) { $module.url } else { $module.name }

        Write-Host "[+] Attempting to install: $($module.name)..."

        # Call VM-Pip-Install per module
        VM-Pip-Install $installValue

        if ($LastExitCode -eq 0) {
            Write-Host "`t[+] Successfully installed: $($module.name)" -ForegroundColor Green
        } else {
            Write-Host "`t[!] Failed to install: $($module.name). Skipping to next..." -ForegroundColor Red
            $failures += $module.name
        }
    }

    # Generate Failure Summary
    if ($failures.Count -gt 0) {
        Write-Host "`n[!] Installation finished with errors. The following modules failed:" -ForegroundColor Yellow
        foreach ($failed in $failures) {
            Write-Host "`t- $failed" -ForegroundColor Red
            VM-Write-Log "ERROR" "Failed to install Python 3.13 module: $failed"
        }
    } else {
        Write-Host "`n[+] All modules installed successfully!" -ForegroundColor Green
    }

    # Add Monkey Patch to `pyreadline3` for Python 3.13 compatibility
    $sitePackages = py -3.13 -c "import site; print(site.getsitepackages()[1])"
    $potentialPath = Join-Path $sitePackages "readline.py"
    if (Test-Path $potentialPath) {
        $targetFile = $potentialPath
    } else {
        # Fallback, just in case.
        try {
            $targetFile = py -3.13 -c "import readline; print(readline.__file__)"
        } catch {
            $targetFile = $null
        }
    }

    if ($targetFile -and (Test-Path $targetFile)) {
        $content = Get-Content $targetFile -Raw
        if ($content -match "backend = 'pyreadline'") {
            Write-Host "Already patched!" -ForegroundColor Yellow
        } else {
            Add-Content -Path $targetFile -Value "`n# Patch for Python 3.13`nbackend = 'pyreadline'"
            Write-Host "Patch applied to: $targetFile" -ForegroundColor Green
        }
    } else {
        Write-Host "Could not locate readline file." -ForegroundColor Red
    }

    # Avoid WARNINGs to fail the package install
    exit 0
} catch {
    VM-Write-Log-Exception $_
}