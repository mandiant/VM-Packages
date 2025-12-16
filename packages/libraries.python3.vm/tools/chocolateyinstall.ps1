$ErrorActionPreference = 'Continue'
Import-Module vm.common -Force -DisableNameChecking

try {
    $toolDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
    $modulesPath = Join-Path $toolDir "modules.xml" -Resolve
    $modulesXml = [xml](Get-Content $modulesPath)

    # Fix pip version
    VM-Pip-Install "pip~=23.2.1"

    $failures = @()
    $modules = $modulesXml.modules.module
    foreach ($module in $modules) {
        Write-Host "[+] Attempting to install Python3 module: $($module.name)"
        $installValue = $module.name
        if ($module.url) {
            $installValue = $module.url
        }

        VM-Pip-Install $installValue

        if ($LastExitCode -eq 0) {
            Write-Host "`t[+] Installed Python 3.13 module: $($module.name)" -ForegroundColor Green
        } else {
            Write-Host "`t[!] Failed to install Python 3.13 module: $($module.name)" -ForegroundColor Red
            $failures += $module.Name
        }
    }

    if ($failures.Count -gt 0) {
        foreach ($module in $failures) {
            VM-Write-Log "ERROR" "Failed to install Python 3.13 module: $module"
        }
        $outputFile = $outputFile.replace('lib\', 'lib-bad\')
        VM-Write-Log "ERROR" "Check $outputFile for more information"
        exit 1
    }

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
    }

    # Avoid WARNINGs to fail the package install
    exit 0
} catch {
    VM-Write-Log-Exception $_
}
