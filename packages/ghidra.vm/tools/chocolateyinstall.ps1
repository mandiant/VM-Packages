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
  $target = Join-Path $installDir "ghidraRun.bat" -Resolve
  $icon = Join-Path $installDir "support/ghidra.ico" -Resolve
  Install-BinFile -Name $toolName -Path $target

  $shortcutDir = Join-Path ${Env:TOOL_LIST_DIR} $category
  $shortcut = Join-Path $shortcutDir "$toolName.lnk"
  $executablePath = Join-Path ${Env:ChocolateyInstall} $shimPath -Resolve
  Install-ChocolateyShortcut -shortcutFilePath $shortcut -targetPath $executablePath -RunAsAdmin -IconLocation $icon
  VM-Assert-Path $shortcut

  # Attempt to set JDK_HOME for Ghidra
  $openjdkPath = Join-Path ${Env:ProgramFiles} "OpenJDK"
  if (Test-Path $openjdkPath) {
    $files = Get-ChildItem -Path $openjdkPath -Filter openjdk* | Sort-Object -Descending
    if ($files.count -gt 0) {
        $selectedDir = $files | Select-Object -first 1
        $openjdkPath = Join-Path $openjdkPath $selectedDir
        Install-ChocolateyEnvironmentVariable -VariableName "JDK_HOME" -VariableValue $openjdkPath -VariableType 'Machine'

        # Add it do ghidra's config file as well
        $configPath = Join-Path ${Env:UserProfile} ".ghidra"
        New-Item -Path $configPath -ItemType directory -Force | Out-Null
        $configPath = Join-Path $configPath ".$versionPath"
        New-Item -Path $configPath -ItemType directory -Force | Out-Null
        $configPath = Join-Path $configPath "java_home.save"
        New-Item -Path $configPath -ItemType file -Force | Out-Null
        Set-Content -Path $configPath -Value $openjdkPath -Force
    } else {
        $err_msg = "Could not find correct openjdk directory"
        FE-Write-Log "ERROR" $err_msg
    }
  }
} catch {
  VM-Write-Log-Exception $_
}
