$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

try {
  $toolName = 'ghidra'
  $category = 'Disassemblers'
  $shimPath = 'bin\ghidra.exe'
  $versionPath = 'ghidra_10.1.2_PUBLIC'

  $toolsDir = $(Split-Path -parent $MyInvocation.MyCommand.Definition)
  # get path to ghidra dependency directory
  $toolsDir = $toolsDir -replace ".vm"
  $installDir = Join-Path $toolsDir $versionPath
  $target = Join-Path $installDir "ghidraRun.bat"
  $icon = Join-Path $installDir -ChildPath 'support/ghidra.ico'
  Install-BinFile -Name $toolName -Path $target

  $shortcutDir = Join-Path ${Env:TOOL_LIST_DIR} $category
  $shortcut = Join-Path $shortcutDir "$toolName.lnk"
  $executablePath = Join-Path ${Env:ChocolateyInstall} $shimPath -Resolve
  Install-ChocolateyShortcut -shortcutFilePath $shortcut -targetPath $executablePath -RunAsAdmin -IconLocation $icon
  VM-Assert-Path $shortcut
} catch {
  VM-Write-Log-Exception $_
}

# Attempt to set JDK_HOME for Ghidra
$openjdk_path = Join-Path ${Env:ProgramFiles} "OpenJDK"
if (Test-Path $openjdk_path) {
  $files = Get-ChildItem -Path $openjdk_path -Filter openjdk* | Sort-Object -Descending
  if ($files.count -gt 0) {
    $selected_dir = $files | Select-Object -first 1
    $openjdk_path = Join-Path $openjdk_path $selected_dir
    Install-ChocolateyEnvironmentVariable -VariableName "JDK_HOME" -VariableValue $openjdk_path -VariableType 'Machine'

    # Add it do their config file as well
    $config_path = Join-Path ${Env:UserProfile} ".ghidra"
    New-Item -Path $config_path -ItemType directory -Force | Out-Null
    $config_path = Join-Path $config_path ".$versionPath"
    New-Item -Path $config_path -ItemType directory -Force | Out-Null
    $config_path = Join-Path $config_path "java_home.save"
    New-Item -Path $config_path -ItemType file -Force | Out-Null
    Set-Content -Path $config_path -Value $openjdk_path -Force
  } else {
    $err_msg = "Could not find correct openjdk directory"
    FE-Write-Log "ERROR" $err_msg
  }
}
