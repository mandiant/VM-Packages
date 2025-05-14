$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

try {
    $toolName = 'nmap'
    $category = VM-Get-Category($MyInvocation.MyCommand.Definition)
    $shortcutDir = Join-Path ${Env:TOOL_LIST_DIR} $category
    $toolDir = Join-Path ${Env:RAW_TOOLS_DIR} $toolName

    $exeUrl = 'https://nmap.org/dist/nmap-7.94-setup.exe'
    $exeSha256 = 'b99c4535e1603a2150e4dd97933b69bfddf23e8cceff5c36606ec0327c6f7193'
    $installerName = Split-Path -Path $exeUrl -Leaf

    $packageArgs = @{
        packageName   = ${Env:ChocolateyPackageName}
        url           = $exeUrl
        checksum      = $exeSha256
        checksumType  = "sha256"
        fileFullPath  = Join-Path ${Env:TEMP} $installerName
    }
    Get-ChocolateyWebFile @packageArgs
    VM-Assert-Path $packageArgs.fileFullPath

    # AutoHotkey the installer
    $ahkInstaller = Join-Path $(Split-Path $MyInvocation.MyCommand.Definition) "install.ahk" -Resolve
    $rc = (Start-Process -FilePath $ahkInstaller -ArgumentList "$($packageArgs.fileFullPath) $toolDir" -PassThru -Wait).ExitCode
    if ($rc -eq 1) {
        throw "AutoHotKey returned a failure exit code ($rc) for: ${Env:ChocolateyPackageName}"
    } else {
        VM-Assert-Path $(Join-Path $toolDir "nmap.exe")
    }

    # Add shortcuts for all the EXE's (besides Zenmap since it's not a console application)
    $exePaths = Get-ChildItem $toolDir | Where-Object { $_.Name -match '^.*(?<!Uninstall|zenmap)\.exe$' }
    $executableCmd  = Join-Path ${Env:WinDir} "system32\cmd.exe"
    $executableDir  = Join-Path ${Env:UserProfile} "Desktop"
    foreach ($exe in $exePaths) {
        $shortcut = Join-Path $shortcutDir "$($exe.Basename).lnk"
        $executablePath = $exe.FullName
        $executableArgs = "/K `"cd `"$executableDir`" && `"$executablePath`" --help`""
        Install-ChocolateyShortcut -shortcutFilePath $shortcut -targetPath $executableCmd -Arguments $executableArgs -WorkingDirectory $executableDir -RunAsAdmin
        VM-Assert-Path $shortcut
        Install-BinFile -Name $exe.Basename -Path $exe.FullName
    }

    # Add shortcut for Zenmap
    $executablePath = Join-Path $toolDir "zenmap.exe" -Resolve
    $shortcut = Join-Path $shortcutDir "zenmap.lnk"
    Install-ChocolateyShortcut -shortcutFilePath $shortcut -targetPath $executablePath -WorkingDirectory $executableDir -RunAsAdmin
    VM-Assert-Path $shortcut
    Install-BinFile -Name "zenmap" -Path $executablePath
} catch {
    VM-Write-Log-Exception $_
}

