$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

try{
    $toolName = 'HashCalc'
    $toolDir = Join-Path ${Env:RAW_TOOLS_DIR} $toolName
    $category = 'Utilities'

    $zipUrl = 'https://www.slavasoft.com/zip/hashcalc.zip'
    $zipSha256 = '70d2197be429a63e737747f356d0658764b35d194cdbad9ee1bdeb30c8641d90'
    $installerName = 'setup.exe'

    $packageArgs = @{
        packageName = 'HashCalc'
        Url = $zipUrl
        checksum = $zipSha256
        checksumType = "sha256"
        UnzipLocation = $toolDir
    }

    Install-ChocolateyZipPackage @packageArgs
    VM-Assert-Path (Join-Path $toolDir $installerName)

    # AutoHotkey the installer
    $ahkInstaller = Join-Path $toolDir 'setup.exe' -Resolve
    $rc = (Start-Process -FilePath $ahkInstaller -ArgumentList '/VERYSILENT', '/DIR=C:\Tools\HashCalc' -PassThru -Wait).ExitCode
    if ($rc -eq 1) {
        throw "AutoHotKey returned a failure exit code ($rc) for: ${Env:ChocolateyPackageName}"
    } else {
        VM-Assert-Path $(Join-Path $toolDir "HashCalc.exe")
        # Remove setup file
        Get-ChildItem $Env:RAW_TOOLS_DIR\$toolName\setup.exe | ForEach-Object { Remove-Item $_ }
        # Remove desktop shortcut
        Get-ChildItem $Env:USERPROFILE\Desktop\HashCalc.lnk | ForEach-Object { Remove-Item $_ }
    }

    # Adding shortcuts for HashCalc
    $executableDir  = Join-Path ${Env:USERPROFILE} "Desktop"
    $executablePath = Join-Path $toolDir "HashCalc.exe"
    $shortcutDir = Join-Path ${Env:TOOL_LIST_DIR} $category
    $shortcut = Join-Path $shortcutDir "HashCalc.lnk"
    Install-ChocolateyShortcut -shortcutFilePath $shortcut -targetPath $executablePath -WorkingDirectory $executableDir -RunAsAdmin
    VM-Assert-Path $shortcut
    Install-BinFile -Name "HashCalc" -Path $executablePath

} catch {
    VM-Write-Log-Exception $_
}