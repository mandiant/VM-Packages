$ErrorActionPreference = 'Continue'
Import-Module vm.common -Force -DisableNameChecking

try {
    $toolDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
    $modulesPath = Join-Path $toolDir "modules.xml" -Resolve
    $modulesXml = [xml](Get-Content $modulesPath)

    # Create output file to log python module uninstallation details
    $outputFile = VM-New-Install-Log $toolDir

    # Upgrade pip
    Invoke-Expression "py -2 -m pip install -qq --no-cache-dir --upgrade pip 2>&1 >> $outputFile"

    $success = $true
    $modules = $modulesXml.modules.module
    foreach ($module in $modules) {
        VM-Write-Log "INFO" "Attempting to uninstall Python2 module: $($module.name)"

        Invoke-Expression "py -2 -m pip uninstall -y $($module.name) 2>&1 >> $outputFile"

        if ($LastExitCode -eq 0) {
            VM-Write-Log "INFO" "Uninstalled Python2 module: $($module.name)"
        } else {
            VM-Write-Log "ERROR" "Failed to uninstall Python2 module: $($module.name)"
            $success = $false
        }
    }

    if ($success -eq $false) {
        VM-Write-Log "ERROR" "Failed to uninstall at least one Python2 module"
        $outputFile = $outputFile.replace('lib\', 'lib-bad\')
        VM-Write-Log "ERROR" "Check $outputFile for more information"
        VM-Write-Log "ERROR" "Please manually uninstall the remaining Python2 modules via:`n`tpy -2 -m pip uninstall -y <module_name>"
    }
} catch {
    VM-Write-Log-Exception $_
}

