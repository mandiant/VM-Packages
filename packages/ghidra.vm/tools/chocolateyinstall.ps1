$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

try {
    $toolName = 'ghidra'
    $category = 'Disassemblers'
    $shimPath = 'bin\ghidra.exe'
    $versionPath = 'ghidra_' + $env:ChocolateyPackageVersion + '_PUBLIC'

    $toolsDir = $(Split-Path -parent $MyInvocation.MyCommand.Definition)
    # Get path to ghidra dependency directory
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
    $jdkPath = Join-Path ${Env:ProgramFiles} "OpenJDK"
    if (Test-Path $jdkPath) {
        $files = Get-ChildItem -Path $jdkPath -Filter jdk* | Sort-Object -Descending
        if ($files.count -gt 0) {
            $selectedDir = $files | Select-Object -first 1
            $jdkPath = Join-Path $jdkPath $selectedDir
            Install-ChocolateyEnvironmentVariable -VariableName "JDK_HOME" -VariableValue $jdkPath -VariableType 'Machine'

            # Add it do ghidra's config file as well
            $configPath = Join-Path ${Env:UserProfile} ".ghidra"
            New-Item -Path $configPath -ItemType directory -Force | Out-Null
            $configPath = Join-Path $configPath ".$versionPath"
            New-Item -Path $configPath -ItemType directory -Force | Out-Null
            $configPath = Join-Path $configPath "java_home.save"
            New-Item -Path $configPath -ItemType file -Force | Out-Null
            Set-Content -Path $configPath -Value $jdkPath -Force
        } else {
            $err_msg = "Could not find correct JDK directory"
            VM-Write-Log "WARN" $err_msg
        }
    } else {
        $err_msg = "Could not find Java directory"
        VM-Write-Log "WARN" $err_msg
    }
} catch {
    VM-Write-Log-Exception $_
}

