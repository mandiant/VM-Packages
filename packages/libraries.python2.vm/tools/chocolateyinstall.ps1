$ErrorActionPreference = 'Continue'
Import-Module vm.common -Force -DisableNameChecking

try {
    $toolDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
    $modulesPath = Join-Path $toolDir "modules.xml" -Resolve
    $modulesXml = [xml](Get-Content $modulesPath)

    # Create output file to log python module installation details
    $outputFile = VM-New-Install-Log $toolDir

    # Upgrade pip
    Invoke-Expression "py -2 -m pip install -qq --no-cache-dir --upgrade pip 2>&1 >> $outputFile"

    $success = $true
    $modules = $modulesXml.modules.module
    foreach ($module in $modules) {
        VM-Write-Log "INFO" "Attempting to install Python2 module: $($module.name)"
        $intallValue = $module.name
        if ($module.url) {
            $intallValue = $module.url
        }

        Invoke-Expression "py -2 -m pip install $intallValue 2>&1 >> $outputFile"

        if ($LastExitCode -eq 0) {
            VM-Write-Log "INFO" "Installed Python2 module: $($module.name)"
        } else {
            VM-Write-Log "ERROR" "Failed to install Python2 module: $($module.name)"
            $success = $false
        }
    }

    if ($success -eq $false) {
        VM-Write-Log "ERROR" "Failed to install at least one Python2 module"
        $outputFile = $outputFile.replace('lib\', 'lib-bad\')
        VM-Write-Log "ERROR" "Check $outputFile for more information"
        exit 1
    }
} catch {
    VM-Write-Log-Exception $_
}

