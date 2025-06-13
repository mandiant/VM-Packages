$ErrorActionPreference = 'Continue'
Import-Module vm.common -Force -DisableNameChecking

try {
    $toolDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
    $modulesPath = Join-Path $toolDir "modules.xml" -Resolve
    $modulesXml = [xml](Get-Content $modulesPath)

    # Fix pip version
    VM-Pip-Install "pip~=25.1.1"

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
    # Avoid WARNINGs to fail the package install
    exit 0
} catch {
    VM-Write-Log-Exception $_
}
