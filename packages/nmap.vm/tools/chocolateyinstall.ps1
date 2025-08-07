$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

try {
    $toolName = 'nmap'
    $category = VM-Get-Category($MyInvocation.MyCommand.Definition)
    $shortcutDir = Join-Path ${Env:TOOL_LIST_DIR} $category
    $toolDir = Join-Path ${Env:RAW_TOOLS_DIR} $toolName

    $exeUrl = 'https://nmap.org/dist/nmap-7.97-setup.exe'
    $exeSha256 = 'd953719622808d1f58fb65ad2ddf3e7d03e33f1105c6d422b76e420ad6e1f45f'
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
    $originalShortcut = Join-Path $toolDir "zenmap.lnk"
    VM-Assert-Path $originalShortcut
    # Add run as admin shortcut to $shortcutDir
    $newAdminShortcut = Join-Path $shortcutDir "zenmap.lnk"
    Install-ChocolateyShortcut -shortcutFilePath $newAdminShortcut -targetPath $originalShortcut -WorkingDirectory $toolDir -RunAsAdmin
    VM-Assert-Path $newAdminShortcut
} catch {
    VM-Write-Log-Exception $_
}

