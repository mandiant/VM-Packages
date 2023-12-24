$ErrorActionPreference = 'Stop'

$packageToolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$moduleName = "vm.common"


# ################################################################################################ #
# Utility functions
# ################################################################################################ #

function Set-EnvironmentVariableWrap([string] $key, [string] $value)
{
<#
.SYNOPSIS
    Set the environment variable for all process, user and system wide scopes
.OUTPUTS
    True on success | False on error
#>
    try {
        [Environment]::SetEnvironmentVariable($key, $value)
        [Environment]::SetEnvironmentVariable($key, $value, 1)
        [Environment]::SetEnvironmentVariable($key, $value, 2)

        $rc = $true
    } catch {
        $rc = $false
    }
    $rc
}


# ################################################################################################ #
# \ \ ---------------------------------------- N O T E ---------------------------------------- / /
#
#     Below are user configurable environment variables
#
# ################################################################################################ #


# ################################################################################################ #
# Default path to the common directory for VMs
# ################################################################################################ #
$envVarName = "VM_COMMON_DIR"
$commonDirPath = [Environment]::GetEnvironmentVariable($envVarName, 2)
if ((-Not (Test-Path env:\$envVarName)) -Or ($commonDirPath -eq $null)) {
    $commonDirPath = Join-Path ${Env:ProgramData} "_VM"
    if (-Not (Test-Path $commonDirPath)) {
        New-Item -Path $commonDirPath -ItemType directory -Force | Out-Null
    }

    Install-ChocolateyEnvironmentVariable -VariableName $envVarName -VariableValue $commonDirPath -VariableType 'Machine'
    Set-Item "Env:$envVarName" $commonDirPath -Force
}
Write-Host -ForegroundColor Green "[+] VM_COMMON_DIR set to:" $commonDirPath

# If the user set the env var but the folder doesn't exist, create it
$commonDirPath = [Environment]::ExpandEnvironmentVariables("%$envVarName%")
if (-Not (Test-Path $commonDirPath)) {
    New-Item -Path $commonDirPath -ItemType directory -Force | Out-Null
    Write-Host -ForegroundColor Green "[+] Created folder:" $commonDirPath
}

# Copy the directory for common modules for VMs to the common directory
Copy-Item -Path (Join-Path $packageToolsDir $moduleName) -Destination $commonDirPath -Recurse -Force


# ################################################################################################ #
# Add the common directory to the PSModulePath if it's not already present
# ################################################################################################ #
$envVarName = "PSModulePath"
$curModulePaths = [Environment]::GetEnvironmentVariable($envVarName, 2)
if (-Not $curModulePaths) {
    $prevPath = Join-Path ${Env:ProgramFiles} "\WindowsPowerShell\Modules"
} else {
    # Remove the previous common directory path if it is already present
    $prevPath = ($curModulePaths -Split ';' | Where-Object { !($_.ToLower() -Match "\\$($commonDirPath.split("\\")[-1])")}) -Join ';'
}

# Update the PSModulePath env var
$prevPath = "$commonDirPath;$prevPath"
Install-ChocolateyEnvironmentVariable -VariableName $envVarName -VariableValue $prevPath -VariableType 'Machine'
${Env:PSModulePath} = "$commonDirPath;${Env:PSModulePath}"
Write-Host -ForegroundColor Green "[+] PSModulePath set to:" $prevPath


# ################################################################################################ #
# Setup the default tool list directory and env var if it doesn't exist
# ################################################################################################ #
$envVarName = "TOOL_LIST_DIR"
$toolListDir = [Environment]::GetEnvironmentVariable($envVarName, 2)
if (-Not (Test-Path env:\$envVarName) -Or ($toolListDir -eq $null)) {
    $toolListDir = Join-Path ${Env:USERPROFILE} "Desktop\Tools"
    if (-Not (Test-Path $toolListDir) ) {
        New-Item -Path $toolListDir -ItemType directory -Force | Out-Null
    }

    Install-ChocolateyEnvironmentVariable -VariableName $envVarName -VariableValue $toolListDir -VariableType 'Machine'
    Set-Item "Env:$envVarName" $toolListDir -Force
}
Write-Host -ForegroundColor Green "[+] TOOL_LIST_DIR set to:" $toolListDir

# If the user set the env var but the folder doesn't exist, create it
$toolListDir = [Environment]::ExpandEnvironmentVariables("%$envVarName%")
if (-Not (Test-Path $toolListDir)) {
    New-Item -Path $toolListDir -ItemType directory -Force | Out-Null
    Write-Host -ForegroundColor Green "[+] Created folder:" $toolListDir
}

# ################################################################################################ #
# Set up the default raw tools directory and env var if it doesn't exist
# ################################################################################################ #
$envVarName = "RAW_TOOLS_DIR"
$rawToolsDir = [Environment]::GetEnvironmentVariable($envVarName, 2)
if ((-Not (Test-Path env:\$envVarName)) -Or ($rawToolsDir -eq $null)) {
    $rawToolsDir = Join-Path ${Env:SystemDrive} "Tools"
    if (-Not (Test-Path $rawToolsDir) ) {
        New-Item -Path $rawToolsDir -ItemType directory -Force | Out-Null
    }

    Install-ChocolateyEnvironmentVariable -VariableName $envVarName -VariableValue $rawToolsDir -VariableType 'Machine'
    Set-Item "Env:$envVarName" $rawToolsDir -Force
}
Write-Host -ForegroundColor Green "[+] RAW_TOOLS_DIR set to:" $rawToolsDir

# If the user set the env var but the folder doesn't exist, create it
$rawToolsDir = [Environment]::ExpandEnvironmentVariables("%$envVarName%")
if (-Not (Test-Path $rawToolsDir))
{
    New-Item -Path $rawToolsDir -ItemType directory -Force | Out-Null
    Write-Host -ForegroundColor Green "[+] Created folder:" $rawToolsDir
}
Set-EnvironmentVariableWrap "ChocolateyToolsLocation" $rawToolsDir | Out-Null

# Refresh all env vars for this PS session
refreshenv | Out-null

