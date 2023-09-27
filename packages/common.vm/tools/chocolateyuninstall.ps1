$ErrorActionPreference = 'Continue'

$commonDirPath = [Environment]::GetEnvironmentVariable("VM_COMMON_DIR", 'Machine')

# Reset the PSModulePath env var
$envVarName = "PSModulePath"
$modulePaths = [Environment]::GetEnvironmentVariable($envVarName, 'Machine')
if ($modulePaths) {
  # Remove the previous vm.common module path
  $prevPath = ($modulePaths -Split ';' | Where-Object { !($_.ToLower() -Match "\\$($commonDirPath.split("\\")[-1])")}) -Join ';'
}
else {
  $prevPath = Join-Path ${Env:ProgramFiles} "\WindowsPowerShell\Modules"
}
Install-ChocolateyEnvironmentVariable -VariableName $envVarName -VariableValue $prevPath -VariableType 'Machine'
Set-Item "Env:$envVarName" $prevPath -Force

# Remove the env vars and what they point to
# NOTE: Purposefully NOT recursively deleting RAW_TOOLS_DIR as the user may have other items there
$envVarNames = @("VM_CONFIG", "TOOL_LIST_DIR", "VM_COMMON_DIR")
foreach ($envVarName in $envVarNames) {
  if (Test-Path env:\$envVarName) {
    $envVarValue = [Environment]::GetEnvironmentVariable($envVarName, 'Machine')
    if ($envVarValue -ne $null -And (Test-Path $envVarValue)) {
      Remove-Item -Path $envVarValue -Recurse -ErrorAction SilentlyContinue -Force
    }
    [Environment]::SetEnvironmentVariable($envVarName, $null, "Machine")
    Set-Item "Env:$envVarName" '' -Force
  }
}

# Remove only the env var for RAW_TOOLS_DIR
$envVarName = "RAW_TOOLS_DIR"
[Environment]::SetEnvironmentVariable($envVarName, $null, "Machine")
Set-Item "Env:$envVarName" '' -Force

refreshenv | Out-Null
