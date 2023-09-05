$ErrorActionPreference = 'Continue'
Import-Module vm.common -Force -DisableNameChecking

try {
    $toolDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
    $modulesPath = Join-Path $toolDir "modules.xml" -Resolve
    $modulesXml = [xml](Get-Content $modulesPath)

    # Create output file to log python module installation details
    $outputFile = VM-New-Install-Log $toolDir

    # Fix pip version
    Invoke-Expression "py -3.9 -m pip install pip~=23.2.1 >> $outputFile"

    $failures = @()
    $modules = $modulesXml.modules.module
    foreach ($module in $modules) {
        Write-Host "[+] Attempting to install Python3 module: $($module.name)"
        $intallValue = $module.name
        if ($module.url) {
            $intallValue = $module.url
        }

        Invoke-Expression "py -3.9 -m pip install $intallValue 2>&1 >> $outputFile"

        if ($LastExitCode -eq 0) {
            Write-Host "`t[+] Installed Python 3.9 module: $($module.name)" -ForegroundColor Green
        } else {
            Write-Host "`t[!] Failed to install Python 3.9 module: $($module.name)" -ForegroundColor Red
            $failures += $module.Name
        }
    }

    if ($failures.Count -gt 0) {
        foreach ($module in $failures) {
            VM-Write-Log "ERROR" "Failed to install Python 3.9 module: $module"
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

