$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

try{
    $toolName = 'KeePass'
    $shortcutDir = Join-Path ${Env:TOOL_LIST_DIR} $category
    $toolsDir = Join-Path ${Env:RAW_TOOLS_DIR} $toolName
    $category = 'Utilities'

    $exeUrl = 'https://versaweb.dl.sourceforge.net/project/keepass/KeePass%202.x/2.53.1/KeePass-2.53.1-Setup.exe'
    $exeSha256 = '067727caa782f53f6232f8f59bc945384fce98817b014300039b28487c06a5cd'
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
    $ahkInstaller = Join-Path ${Env:TEMP} $installerName -Resolve
    $rc = (Start-Process -FilePath $ahkInstaller -ArgumentList '/VERYSILENT', '/DIR="C:\Tools\KeePass"' -PassThru -Wait).ExitCode
    if ($rc -eq 1) {
        throw "AutoHotKey returned a failure exit code ($rc) for: ${Env:ChocolateyPackageName}"
    } else {
        VM-Assert-Path $(Join-Path $toolsDir "KeePass.exe")
    }

    # Add shortcuts for KeePass
    $executableDir  = Join-Path ${Env:UserProfile} "Desktop"
    $executablePath = Join-Path $toolsDir "KeePass.exe" -Resolve
    $shortcut = Join-Path $shortcutDir "KeePass.lnk"
    Install-ChocolateyShortcut -shortcutFilePath $shortcut -targetPath $executablePath -WorkingDirectory $executableDir -RunAsAdmin
    VM-Assert-Path $shortcut
    Install-BinFile -Name "KeePass" -Path $executablePath

} catch {
    VM-Write-Log-Exception $_
}


