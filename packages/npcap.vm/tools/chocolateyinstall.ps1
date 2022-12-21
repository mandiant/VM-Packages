$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

try {
    $exeUrl = 'https://npcap.com/dist/npcap-1.72.exe'
    $exeSha256 = 'b0efd269d32e581da747e5050ef98d2eb91e6de9080e0918f5af85b485a4bdd1'
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

    $ahkInstaller = Join-Path $(Split-Path $MyInvocation.MyCommand.Definition) "install.ahk" -Resolve
    $ahkExe = Join-Path ${Env:ChocolateyInstall} "lib\autohotkey.portable\tools\AutoHotkey.exe" -Resolve
    $rc = (Start-Process -FilePath $ahkExe -ArgumentList "$ahkInstaller $($packageArgs.fileFullPath)" -PassThru -Wait).ExitCode
    if ($rc -eq 1) {
        throw "AutoHotKey returned a failure exit code ($rc) for: ${Env:ChocolateyPackageName}"
    } else {
        VM-Assert-Path $(Join-Path ${Env:PROGRAMFILES} "Npcap\npcap.cat")
    }
} catch {
    VM-Write-Log-Exception $_
}

