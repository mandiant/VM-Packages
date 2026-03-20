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
    Invoke-Expression "py -3.10 -W ignore -m pip install $pipVersion --disable-pip-version-check --no-deps --force-reinstall 2>&1 >> $outputFile"


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

<<<<<<< HEAD
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
=======
        if ($LastExitCode -eq 0) {
            Write-Host "`t[+] Installed Python 3.13 module: $($module.name)" -ForegroundColor Green
        } else {
            Write-Host "`t[!] Failed to install Python 3.13 module: $($module.name)" -ForegroundColor Red
            $failures += $module.Name
>>>>>>> 7d42816f (update python to 3.13 and adjusted package dependencies)
        }
    }

    if ($failures.Count -gt 0) {
        foreach ($module in $failures) {
            VM-Write-Log "ERROR" "Failed to install Python 3.13 module: $module"
        }
        throw "Package installation failed. The following modules could not be verified: $($failures -join ', ')"
    }

<<<<<<< HEAD
    # Fix issue with chocolately printing incorrect install directory
    $pythonPath = py -3.10 -c "import sys; print(sys.prefix)" 2>$null
    if ($pythonPath) {
        $env:ChocolateyPackageInstallLocation = $pythonPath
=======
    # Add Monkey Patch to `pyreadline3` for Python 3.13 compatibility
    $sitePackages = python -c "import site; print(site.getsitepackages()[1])"
    $potentialPath = Join-Path $sitePackages "readline.py"
    if (Test-Path $potentialPath) {
        $targetFile = $potentialPath
    } else {
        # Fallback, just in case.
        try {
            $targetFile = & $(Get-Command python).Source -c "import sys; sys.path.append(r'C:\Python313\Lib\site-packages'); import readline; print(readline.__file__)"
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
>>>>>>> 7d42816f (update python to 3.13 and adjusted package dependencies)
    }

    # Avoid WARNINGs to fail the package install
    exit 0
} catch {
    VM-Write-Log-Exception $_
}